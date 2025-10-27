-- =====================================================
-- CRM CONVERSÃO - DATABASE SCHEMA
-- PostgreSQL 14+
-- =====================================================

-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm"; -- Para busca full-text
CREATE EXTENSION IF NOT EXISTS "btree_gin"; -- Para índices compostos

-- =====================================================
-- ENUMS
-- =====================================================

CREATE TYPE user_role AS ENUM ('admin', 'closer', 'sdr', 'viewer');
CREATE TYPE disc_profile AS ENUM ('D', 'I', 'S', 'C');
CREATE TYPE lead_source AS ENUM ('website', 'instagram', 'whatsapp', 'referral', 'cold_call', 'event', 'other');
CREATE TYPE event_status AS ENUM ('scheduled', 'rescheduled', 'cancelled', 'completed', 'no_show');
CREATE TYPE message_channel AS ENUM ('whatsapp', 'instagram', 'internal', 'email');
CREATE TYPE message_direction AS ENUM ('in', 'out');
CREATE TYPE activity_type AS ENUM ('stage_move', 'note', 'task', 'status_change', 'message', 'call_outcome', 'lead_created', 'lead_assigned');
CREATE TYPE task_status AS ENUM ('open', 'done', 'cancelled');
CREATE TYPE integration_vendor AS ENUM ('google', 'waba', 'instagram', 'zoom', 'email');
CREATE TYPE template_type AS ENUM ('whatsapp', 'instagram_dm', 'email', 'script');
CREATE TYPE call_outcome AS ENUM ('completed', 'no_show', 'rescheduled', 'cancelled', 'interested', 'not_interested');

-- =====================================================
-- TABLES
-- =====================================================

-- USERS
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255), -- Pode ser NULL se login via OAuth
    role user_role NOT NULL DEFAULT 'closer',
    timezone VARCHAR(50) DEFAULT 'America/Sao_Paulo',
    avatar_url TEXT,
    phone VARCHAR(20),
    google_calendar_connected BOOLEAN DEFAULT FALSE,
    google_refresh_token TEXT,
    google_access_token TEXT,
    google_token_expires_at TIMESTAMP,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP
);

-- PIPELINES
CREATE TABLE pipelines (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    color VARCHAR(7) DEFAULT '#d2bc8f',
    is_default BOOLEAN DEFAULT FALSE,
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- STAGES (colunas do Kanban)
CREATE TABLE stages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pipeline_id UUID NOT NULL REFERENCES pipelines(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    "order" INTEGER NOT NULL,
    color VARCHAR(7) DEFAULT '#d2bc8f',
    is_closed BOOLEAN DEFAULT FALSE, -- Se é estágio final (ganho/perdido)
    is_won BOOLEAN DEFAULT FALSE, -- Se conta como vitória
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(pipeline_id, "order")
);

-- LEADS
CREATE TABLE leads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(20),
    instagram_handle VARCHAR(255),
    company VARCHAR(255),
    
    -- Pipeline & Stage
    pipeline_id UUID NOT NULL REFERENCES pipelines(id),
    stage_id UUID NOT NULL REFERENCES stages(id),
    
    -- Ownership
    owner_id UUID REFERENCES users(id) ON DELETE SET NULL,
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    
    -- Lead Info
    source lead_source DEFAULT 'other',
    disc_profile disc_profile,
    deal_value NUMERIC(10, 2) DEFAULT 0,
    probability INTEGER DEFAULT 50 CHECK (probability >= 0 AND probability <= 100),
    expected_close_date DATE,
    
    -- AI/ML
    ai_score INTEGER CHECK (ai_score >= 0 AND ai_score <= 100), -- Lead scoring
    ai_disc_suggestion disc_profile, -- Sugestão automática de DISC
    
    -- Metadata
    notes TEXT,
    tags JSONB DEFAULT '[]'::jsonb,
    custom_fields JSONB DEFAULT '{}'::jsonb,
    
    -- Tracking
    last_contact_at TIMESTAMP,
    last_activity_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    
    -- Search optimization
    search_vector tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('portuguese', coalesce(name, '')), 'A') ||
        setweight(to_tsvector('portuguese', coalesce(company, '')), 'B') ||
        setweight(to_tsvector('portuguese', coalesce(notes, '')), 'C')
    ) STORED
);

-- EVENTS (Agendamentos Google Calendar)
CREATE TABLE events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lead_id UUID NOT NULL REFERENCES leads(id) ON DELETE CASCADE,
    google_event_id VARCHAR(255) UNIQUE,
    
    -- Event details
    title VARCHAR(500) NOT NULL,
    description TEXT,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    timezone VARCHAR(50) DEFAULT 'America/Sao_Paulo',
    
    -- Location/Link
    location VARCHAR(500),
    meeting_link TEXT, -- Google Meet, Zoom, etc
    
    -- Status
    status event_status NOT NULL DEFAULT 'scheduled',
    outcome call_outcome,
    outcome_notes TEXT,
    
    -- Participants
    organizer_id UUID REFERENCES users(id) ON DELETE SET NULL,
    attendees JSONB DEFAULT '[]'::jsonb, -- [{email, status, name}]
    
    -- Tracking
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- MESSAGES (WhatsApp, Instagram, Internal)
CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lead_id UUID NOT NULL REFERENCES leads(id) ON DELETE CASCADE,
    
    -- Channel info
    channel message_channel NOT NULL,
    direction message_direction NOT NULL,
    external_id VARCHAR(500), -- ID da mensagem no WhatsApp/Instagram
    
    -- Content
    body TEXT,
    attachments JSONB DEFAULT '[]'::jsonb, -- [{type, url, filename, size}]
    
    -- Status
    status VARCHAR(50) DEFAULT 'sent', -- sent, delivered, read, failed
    error_message TEXT,
    
    -- Tracking
    sent_by UUID REFERENCES users(id) ON DELETE SET NULL,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ACTIVITIES (Histórico/Audit Log)
CREATE TABLE activities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lead_id UUID REFERENCES leads(id) ON DELETE CASCADE,
    
    -- Activity info
    type activity_type NOT NULL,
    title VARCHAR(500),
    description TEXT,
    payload JSONB DEFAULT '{}'::jsonb, -- Dados específicos da atividade
    
    -- Tracking
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Facilita queries por tipo
    is_important BOOLEAN DEFAULT FALSE
);

-- TASKS (Tarefas/Follow-ups)
CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lead_id UUID REFERENCES leads(id) ON DELETE CASCADE,
    
    -- Task info
    title VARCHAR(500) NOT NULL,
    description TEXT,
    due_at TIMESTAMP,
    priority INTEGER DEFAULT 2 CHECK (priority >= 1 AND priority <= 5), -- 1=baixa, 5=crítica
    
    -- Status
    status task_status NOT NULL DEFAULT 'open',
    completed_at TIMESTAMP,
    
    -- Assignment
    assignee_id UUID REFERENCES users(id) ON DELETE SET NULL,
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    
    -- Tracking
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- INTEGRATIONS (Conexões externas)
CREATE TABLE integrations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    
    -- Integration info
    vendor integration_vendor NOT NULL,
    account_id VARCHAR(255), -- Email, phone number, page ID, etc
    account_name VARCHAR(255),
    
    -- Credentials (encrypted)
    credentials JSONB NOT NULL, -- Armazena tokens, secrets (criptografados)
    
    -- Status
    status VARCHAR(50) DEFAULT 'active', -- active, inactive, error
    last_sync_at TIMESTAMP,
    error_message TEXT,
    
    -- Metadata
    meta JSONB DEFAULT '{}'::jsonb,
    
    -- Tracking
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, vendor, account_id)
);

-- TEMPLATES (WhatsApp templates, scripts, emails)
CREATE TABLE templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Template info
    type template_type NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    
    -- Content
    content TEXT NOT NULL, -- Suporta placeholders {{name}}, {{company}}, etc
    variables JSONB DEFAULT '[]'::jsonb, -- Lista de variáveis disponíveis
    
    -- WhatsApp specific
    whatsapp_template_id VARCHAR(255), -- ID aprovado pela Meta
    whatsapp_category VARCHAR(50), -- UTILITY, MARKETING, AUTHENTICATION
    whatsapp_language VARCHAR(10) DEFAULT 'pt_BR',
    approved BOOLEAN DEFAULT FALSE,
    
    -- Metadata
    locale VARCHAR(10) DEFAULT 'pt_BR',
    tags JSONB DEFAULT '[]'::jsonb,
    usage_count INTEGER DEFAULT 0,
    
    -- Tracking
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    
    UNIQUE(type, name)
);

-- WEBHOOKS_LOG (Para debug e auditoria)
CREATE TABLE webhooks_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vendor integration_vendor NOT NULL,
    event_type VARCHAR(100) NOT NULL,
    payload JSONB NOT NULL,
    headers JSONB,
    processed BOOLEAN DEFAULT FALSE,
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- NOTIFICATIONS (Sistema de notificações interno)
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Notification info
    title VARCHAR(500) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) NOT NULL, -- lead_assigned, new_message, task_due, event_reminder, etc
    
    -- Link/Action
    action_url TEXT,
    action_label VARCHAR(100),
    
    -- Related entities
    lead_id UUID REFERENCES leads(id) ON DELETE CASCADE,
    event_id UUID REFERENCES events(id) ON DELETE CASCADE,
    task_id UUID REFERENCES tasks(id) ON DELETE CASCADE,
    
    -- Status
    read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- INDEXES
-- =====================================================

-- Users
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role) WHERE active = TRUE;

-- Leads
CREATE INDEX idx_leads_pipeline_stage ON leads(pipeline_id, stage_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_leads_owner ON leads(owner_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_leads_source ON leads(source);
CREATE INDEX idx_leads_disc ON leads(disc_profile) WHERE disc_profile IS NOT NULL;
CREATE INDEX idx_leads_last_activity ON leads(last_activity_at DESC);
CREATE INDEX idx_leads_search ON leads USING GIN(search_vector);
CREATE INDEX idx_leads_phone ON leads(phone) WHERE phone IS NOT NULL;
CREATE INDEX idx_leads_instagram ON leads(instagram_handle) WHERE instagram_handle IS NOT NULL;
CREATE INDEX idx_leads_tags ON leads USING GIN(tags);

-- Events
CREATE INDEX idx_events_lead ON events(lead_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_events_status ON events(status);
CREATE INDEX idx_events_start_time ON events(start_time);
CREATE INDEX idx_events_google_id ON events(google_event_id) WHERE google_event_id IS NOT NULL;
CREATE INDEX idx_events_organizer ON events(organizer_id);
CREATE INDEX idx_events_upcoming ON events(start_time) WHERE status IN ('scheduled', 'rescheduled') AND deleted_at IS NULL;

-- Messages
CREATE INDEX idx_messages_lead ON messages(lead_id);
CREATE INDEX idx_messages_channel ON messages(channel);
CREATE INDEX idx_messages_timestamp ON messages(timestamp DESC);
CREATE INDEX idx_messages_external_id ON messages(external_id) WHERE external_id IS NOT NULL;
CREATE INDEX idx_messages_unread ON messages(lead_id, read_at) WHERE direction = 'in' AND read_at IS NULL;

-- Activities
CREATE INDEX idx_activities_lead ON activities(lead_id);
CREATE INDEX idx_activities_type ON activities(type);
CREATE INDEX idx_activities_created_at ON activities(created_at DESC);
CREATE INDEX idx_activities_created_by ON activities(created_by);

-- Tasks
CREATE INDEX idx_tasks_lead ON tasks(lead_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_tasks_assignee ON tasks(assignee_id) WHERE status = 'open' AND deleted_at IS NULL;
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_due ON tasks(due_at) WHERE status = 'open' AND deleted_at IS NULL;
CREATE INDEX idx_tasks_priority ON tasks(priority DESC) WHERE status = 'open';

-- Notifications
CREATE INDEX idx_notifications_user_unread ON notifications(user_id, created_at DESC) WHERE read = FALSE;

-- Webhooks
CREATE INDEX idx_webhooks_log_vendor ON webhooks_log(vendor);
CREATE INDEX idx_webhooks_log_created_at ON webhooks_log(created_at DESC);
CREATE INDEX idx_webhooks_log_unprocessed ON webhooks_log(processed) WHERE processed = FALSE;

-- =====================================================
-- FUNCTIONS & TRIGGERS
-- =====================================================

-- Atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Aplicar trigger em todas as tabelas relevantes
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_pipelines_updated_at BEFORE UPDATE ON pipelines FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_stages_updated_at BEFORE UPDATE ON stages FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_leads_updated_at BEFORE UPDATE ON leads FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_events_updated_at BEFORE UPDATE ON events FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_tasks_updated_at BEFORE UPDATE ON tasks FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_integrations_updated_at BEFORE UPDATE ON integrations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_templates_updated_at BEFORE UPDATE ON templates FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Atualizar last_activity_at do lead quando houver atividade
CREATE OR REPLACE FUNCTION update_lead_last_activity()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE leads SET last_activity_at = CURRENT_TIMESTAMP WHERE id = NEW.lead_id;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_lead_activity_on_message AFTER INSERT ON messages FOR EACH ROW EXECUTE FUNCTION update_lead_last_activity();
CREATE TRIGGER update_lead_activity_on_event AFTER INSERT ON events FOR EACH ROW EXECUTE FUNCTION update_lead_last_activity();
CREATE TRIGGER update_lead_activity_on_activity AFTER INSERT ON activities FOR EACH ROW EXECUTE FUNCTION update_lead_last_activity();

-- =====================================================
-- VIEWS ÚTEIS
-- =====================================================

-- View de leads com informações agregadas
CREATE OR REPLACE VIEW leads_with_stats AS
SELECT 
    l.*,
    u.name as owner_name,
    u.email as owner_email,
    s.name as stage_name,
    s.is_closed,
    s.is_won,
    p.name as pipeline_name,
    (SELECT COUNT(*) FROM messages WHERE lead_id = l.id) as messages_count,
    (SELECT COUNT(*) FROM messages WHERE lead_id = l.id AND direction = 'in' AND read_at IS NULL) as unread_messages_count,
    (SELECT COUNT(*) FROM tasks WHERE lead_id = l.id AND status = 'open' AND deleted_at IS NULL) as open_tasks_count,
    (SELECT COUNT(*) FROM events WHERE lead_id = l.id AND status IN ('scheduled', 'rescheduled') AND deleted_at IS NULL) as upcoming_events_count,
    (SELECT MAX(timestamp) FROM messages WHERE lead_id = l.id) as last_message_at,
    EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - l.last_activity_at))/86400 as days_since_last_activity
FROM leads l
LEFT JOIN users u ON l.owner_id = u.id
LEFT JOIN stages s ON l.stage_id = s.id
LEFT JOIN pipelines p ON l.pipeline_id = p.id
WHERE l.deleted_at IS NULL;

-- View de dashboard (métricas)
CREATE OR REPLACE VIEW dashboard_metrics AS
SELECT
    l.owner_id,
    l.pipeline_id,
    DATE_TRUNC('day', l.created_at) as date,
    COUNT(*) FILTER (WHERE l.created_at >= CURRENT_DATE - INTERVAL '30 days') as new_leads_30d,
    COUNT(*) FILTER (WHERE s.is_won AND l.updated_at >= CURRENT_DATE - INTERVAL '30 days') as won_30d,
    COUNT(*) FILTER (WHERE s.is_closed AND NOT s.is_won AND l.updated_at >= CURRENT_DATE - INTERVAL '30 days') as lost_30d,
    SUM(l.deal_value) FILTER (WHERE s.is_won AND l.updated_at >= CURRENT_DATE - INTERVAL '30 days') as revenue_30d,
    AVG(l.deal_value) FILTER (WHERE s.is_won) as avg_deal_value,
    COUNT(DISTINCT e.id) FILTER (WHERE e.created_at >= CURRENT_DATE - INTERVAL '30 days') as events_scheduled_30d,
    COUNT(DISTINCT e.id) FILTER (WHERE e.status = 'completed' AND e.updated_at >= CURRENT_DATE - INTERVAL '30 days') as events_completed_30d,
    COUNT(DISTINCT e.id) FILTER (WHERE e.status = 'no_show' AND e.updated_at >= CURRENT_DATE - INTERVAL '30 days') as no_shows_30d
FROM leads l
LEFT JOIN stages s ON l.stage_id = s.id
LEFT JOIN events e ON l.id = e.lead_id
WHERE l.deleted_at IS NULL
GROUP BY l.owner_id, l.pipeline_id, DATE_TRUNC('day', l.created_at);

-- =====================================================
-- GRANTS (ajuste conforme necessário)
-- =====================================================

-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO your_app_user;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO your_app_user;

-- =====================================================
-- COMMENTS
-- =====================================================

COMMENT ON TABLE leads IS 'Tabela principal de leads/contatos do CRM';
COMMENT ON COLUMN leads.ai_score IS 'Score de 0-100 calculado por IA/ML predizendo probabilidade de conversão';
COMMENT ON COLUMN leads.disc_profile IS 'Perfil comportamental DISC do lead';
COMMENT ON TABLE messages IS 'Histórico de mensagens WhatsApp, Instagram e internas';
COMMENT ON TABLE events IS 'Agendamentos sincronizados com Google Calendar';
COMMENT ON TABLE activities IS 'Log de auditoria de todas as ações no CRM';
