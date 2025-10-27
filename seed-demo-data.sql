-- =====================================================
-- SEED DATA - CRM CONVERSÃO
-- Dados de demonstração para testar o sistema
-- =====================================================

-- Limpar dados existentes (cuidado em produção!)
-- TRUNCATE users, pipelines, stages, leads, events, messages, activities, tasks, integrations, templates CASCADE;

-- =====================================================
-- USERS
-- =====================================================

INSERT INTO users (id, email, name, role, timezone, avatar_url, active) VALUES
('11111111-1111-1111-1111-111111111111', 'admin@crmconversao.com', 'Admin Master', 'admin', 'America/Sao_Paulo', 'https://i.pravatar.cc/150?img=1', TRUE),
('22222222-2222-2222-2222-222222222222', 'joao.closer@crmconversao.com', 'João Silva', 'closer', 'America/Sao_Paulo', 'https://i.pravatar.cc/150?img=12', TRUE),
('33333333-3333-3333-3333-333333333333', 'maria.sdr@crmconversao.com', 'Maria Santos', 'sdr', 'America/Sao_Paulo', 'https://i.pravatar.cc/150?img=45', TRUE),
('44444444-4444-4444-4444-444444444444', 'pedro.closer@crmconversao.com', 'Pedro Costa', 'closer', 'America/Sao_Paulo', 'https://i.pravatar.cc/150?img=33', TRUE);

-- =====================================================
-- PIPELINES
-- =====================================================

INSERT INTO pipelines (id, name, description, color, is_default, created_by) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Pipeline Principal', 'Pipeline padrão para leads de entrada', '#d2bc8f', TRUE, '11111111-1111-1111-1111-111111111111'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Pipeline Corporativo', 'Para vendas B2B e grandes contratos', '#4a90e2', FALSE, '11111111-1111-1111-1111-111111111111');

-- =====================================================
-- STAGES (Pipeline Principal)
-- =====================================================

INSERT INTO stages (id, pipeline_id, name, "order", color, is_closed, is_won) VALUES
-- Pipeline Principal
('s1111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Novo contato', 1, '#94a3b8', FALSE, FALSE),
('s2222222-2222-2222-2222-222222222222', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Diagnóstico agendado', 2, '#60a5fa', FALSE, FALSE),
('s3333333-3333-3333-3333-333333333333', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Call realizada', 3, '#a78bfa', FALSE, FALSE),
('s4444444-4444-4444-4444-444444444444', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Proposta enviada', 4, '#f59e0b', FALSE, FALSE),
('s5555555-5555-5555-5555-555555555555', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Follow-up', 5, '#fbbf24', FALSE, FALSE),
('s6666666-6666-6666-6666-666666666666', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Fechado (ganho)', 6, '#10b981', TRUE, TRUE),
('s7777777-7777-7777-7777-777777777777', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Fechado (perdido)', 7, '#ef4444', TRUE, FALSE),

-- Pipeline Corporativo
('s8888888-8888-8888-8888-888888888888', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Prospecção', 1, '#94a3b8', FALSE, FALSE),
('s9999999-9999-9999-9999-999999999999', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Qualificação', 2, '#60a5fa', FALSE, FALSE),
('saaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Negociação', 3, '#f59e0b', FALSE, FALSE),
('saaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Contrato', 4, '#10b981', TRUE, TRUE),
('saaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Perdido', 5, '#ef4444', TRUE, FALSE);

-- =====================================================
-- LEADS (10 exemplos com perfis DISC variados)
-- =====================================================

INSERT INTO leads (id, name, email, phone, instagram_handle, company, pipeline_id, stage_id, owner_id, created_by, source, disc_profile, deal_value, probability, notes, tags, custom_fields) VALUES

-- Lead 1: Perfil D (Dominante)
('l1111111-1111-1111-1111-111111111111', 
 'Carlos Augusto', 
 'carlos@empresa.com', 
 '+5531999001111', 
 '@carlos_ceo',
 'TechStart LTDA',
 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
 's2222222-2222-2222-2222-222222222222',
 '22222222-2222-2222-2222-222222222222',
 '33333333-3333-3333-3333-333333333333',
 'website',
 'D',
 15000.00,
 80,
 'CEO muito direto. Quer resultados rápidos. Não gosta de enrolação.',
 '["quente", "decisor", "urgente"]'::jsonb,
 '{"budget": "R$ 15-20k", "timeline": "imediato"}'::jsonb),

-- Lead 2: Perfil I (Influente)
('l2222222-2222-2222-2222-222222222222',
 'Ana Paula Marketing',
 'ana@agenciacriativa.com',
 '+5531999002222',
 '@ana_marketing',
 'Agência Criativa',
 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
 's1111111-1111-1111-1111-111111111111',
 '22222222-2222-2222-2222-222222222222',
 '33333333-3333-3333-3333-333333333333',
 'instagram',
 'I',
 8000.00,
 60,
 'Muito comunicativa e animada. Gosta de cases de sucesso e referências.',
 '["morno", "influenciador", "social"]'::jsonb,
 '{"interest": "marketing automation", "team_size": "5-10"}'::jsonb),

-- Lead 3: Perfil S (Estável)
('l3333333-3333-3333-3333-333333333333',
 'Roberto Oliveira',
 'roberto@construtorasolida.com',
 '+5531999003333',
 NULL,
 'Construtora Sólida',
 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
 's4444444-4444-4444-4444-444444444444',
 '22222222-2222-2222-2222-222222222222',
 '33333333-3333-3333-3333-333333333333',
 'referral',
 'S',
 12000.00,
 70,
 'Pessoa calma, metódica. Precisa de tempo para decidir. Valoriza relacionamento.',
 '["relacionamento", "longo-prazo"]'::jsonb,
 '{"referred_by": "Cliente Antigo", "decision_time": "30-45 dias"}'::jsonb),

-- Lead 4: Perfil C (Cauteloso)
('l4444444-4444-4444-4444-444444444444',
 'Dra. Fernanda Costa',
 'fernanda@clinicaexcelencia.com',
 '+5531999004444',
 '@dra_fernanda',
 'Clínica Excelência',
 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
 's5555555-5555-5555-5555-555555555555',
 '44444444-4444-4444-4444-444444444444',
 '33333333-3333-3333-3333-333333333333',
 'whatsapp',
 'C',
 20000.00,
 50,
 'Muito analítica. Pede muitos detalhes técnicos, relatórios, dados. Perfeccionista.',
 '["analítico", "detalhista", "dados"]'::jsonb,
 '{"concerns": ["ROI", "compliance", "suporte"], "research_stage": "avançado"}'::jsonb),

-- Lead 5: Perfil D (Dominante) - Estágio inicial
('l5555555-5555-5555-5555-555555555555',
 'Marcos Vinicius',
 'marcos@startuptech.io',
 '+5531999005555',
 '@mvtech',
 'StartupTech',
 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
 's1111111-1111-1111-1111-111111111111',
 '22222222-2222-2222-2222-222222222222',
 '33333333-3333-3333-3333-333333333333',
 'event',
 'D',
 30000.00,
 40,
 'Fundador de startup. Extremamente ocupado. Quer escalabilidade.',
 '["startup", "tech", "escalável"]'::jsonb,
 '{"funding_stage": "Series A", "growth_rate": "300% YoY"}'::jsonb),

-- Lead 6: Perfil I (Influente) - Call realizada
('l6666666-6666-6666-6666-666666666666',
 'Juliana Mendes',
 'ju@influncerslab.com',
 '+5531999006666',
 '@ju_influencer',
 'Influencers Lab',
 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
 's3333333-3333-3333-3333-333333333333',
 '44444444-4444-4444-4444-444444444444',
 '33333333-3333-3333-3333-333333333333',
 'instagram',
 'I',
 5000.00,
 75,
 'Gestora de influencers. Super conectada. Quer algo "instagramável".',
 '["influencer", "social-media", "visual"]'::jsonb,
 '{"instagram_followers": "50k", "niche": "lifestyle"}'::jsonb),

-- Lead 7: Perfil S (Estável) - Ganho
('l7777777-7777-7777-7777-777777777777',
 'Paulo Henrique',
 'paulo@empresafamiliar.com.br',
 '+5531999007777',
 NULL,
 'Empresa Familiar Silva',
 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
 's6666666-6666-6666-6666-666666666666',
 '22222222-2222-2222-2222-222222222222',
 '22222222-2222-2222-2222-222222222222',
 'cold_call',
 'S',
 18000.00,
 100,
 'Empresa familiar há 40 anos. Valorizam muito confiança e suporte.',
 '["cliente", "fidelidade", "suporte"]'::jsonb,
 '{"years_in_business": "40", "employees": "50"}'::jsonb),

-- Lead 8: Perfil C (Cauteloso) - Perdido
('l8888888-8888-8888-8888-888888888888',
 'Sandra Regina',
 'sandra@consultoriatecnica.com',
 '+5531999008888',
 NULL,
 'Consultoria Técnica SR',
 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
 's7777777-7777-7777-7777-777777777777',
 '44444444-4444-4444-4444-444444444444',
 '22222222-2222-2222-2222-222222222222',
 'website',
 'C',
 25000.00,
 0,
 'Optou por concorrente devido a recursos técnicos específicos que não tínhamos.',
 '["perdido", "concorrência", "features"]'::jsonb,
 '{"lost_reason": "missing features", "competitor": "Concorrente X"}'::jsonb),

-- Lead 9: Perfil D - Pipeline Corporativo
('l9999999-9999-9999-9999-999999999999',
 'Ricardo Almeida',
 'ricardo@megacorp.com.br',
 '+5531999009999',
 NULL,
 'MegaCorp S.A.',
 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
 's9999999-9999-9999-9999-999999999999',
 '22222222-2222-2222-2222-222222222222',
 '11111111-1111-1111-1111-111111111111',
 'referral',
 'D',
 150000.00,
 65,
 'VP de Operações. Deal grande. Múltiplos stakeholders.',
 '["enterprise", "multi-stakeholder", "committee"]'::jsonb,
 '{"employees": "500+", "decision_makers": "5", "procurement_process": "formal"}'::jsonb),

-- Lead 10: Perfil I - Novo contato
('laaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
 'Thiago Ribeiro',
 'thiago@digitalagency.com',
 '+5531999000000',
 '@thiago_digital',
 'Digital Agency Pro',
 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
 's1111111-1111-1111-1111-111111111111',
 '33333333-3333-3333-3333-333333333333',
 '33333333-3333-3333-3333-333333333333',
 'whatsapp',
 'I',
 7500.00,
 45,
 'Veio pelo WhatsApp. Muito animado com o produto.',
 '["novo", "whatsapp", "quente"]'::jsonb,
 '{"first_contact": "whatsapp", "interest_level": "high"}'::jsonb);

-- =====================================================
-- EVENTS (Agendamentos)
-- =====================================================

INSERT INTO events (id, lead_id, title, description, start_time, end_time, location, meeting_link, status, organizer_id, created_by) VALUES

-- Call agendada (futuro)
('e1111111-1111-1111-1111-111111111111',
 'l1111111-1111-1111-1111-111111111111',
 'Carlos Augusto | Diagnóstico',
 'Call de diagnóstico com CEO da TechStart',
 CURRENT_TIMESTAMP + INTERVAL '2 days',
 CURRENT_TIMESTAMP + INTERVAL '2 days' + INTERVAL '1 hour',
 'Google Meet',
 'https://meet.google.com/abc-defg-hij',
 'scheduled',
 '22222222-2222-2222-2222-222222222222',
 '22222222-2222-2222-2222-222222222222'),

-- Call realizada (passado)
('e2222222-2222-2222-2222-222222222222',
 'l3333333-3333-3333-3333-333333333333',
 'Roberto Oliveira | Follow-up',
 'Apresentação da proposta',
 CURRENT_TIMESTAMP - INTERVAL '3 days',
 CURRENT_TIMESTAMP - INTERVAL '3 days' + INTERVAL '45 minutes',
 'Google Meet',
 'https://meet.google.com/xyz-abcd-efg',
 'completed',
 '22222222-2222-2222-2222-222222222222',
 '22222222-2222-2222-2222-222222222222'),

-- No-show
('e3333333-3333-3333-3333-333333333333',
 'l2222222-2222-2222-2222-222222222222',
 'Ana Paula | Primeiro contato',
 'Call inicial de qualificação',
 CURRENT_TIMESTAMP - INTERVAL '1 day',
 CURRENT_TIMESTAMP - INTERVAL '1 day' + INTERVAL '30 minutes',
 'Zoom',
 'https://zoom.us/j/123456789',
 'no_show',
 '22222222-2222-2222-2222-222222222222',
 '22222222-2222-2222-2222-222222222222');

-- =====================================================
-- MESSAGES (Histórico de mensagens)
-- =====================================================

INSERT INTO messages (id, lead_id, channel, direction, body, timestamp, sent_by) VALUES

-- WhatsApp - Inbound
('m1111111-1111-1111-1111-111111111111',
 'laaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
 'whatsapp',
 'in',
 'Oi! Vi vocês no Instagram e me interessei muito pelo serviço. Podemos conversar?',
 CURRENT_TIMESTAMP - INTERVAL '2 hours',
 NULL),

-- WhatsApp - Outbound
('m2222222-2222-2222-2222-222222222222',
 'laaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
 'whatsapp',
 'out',
 'Olá Thiago! Que legal que você se interessou! 😊 Claro que podemos conversar. Qual o melhor horário para você?',
 CURRENT_TIMESTAMP - INTERVAL '2 hours' + INTERVAL '5 minutes',
 '33333333-3333-3333-3333-333333333333'),

-- Instagram - Inbound
('m3333333-3333-3333-3333-333333333333',
 'l6666666-6666-6666-6666-666666666666',
 'instagram',
 'in',
 'Adorei o conteúdo de vocês! Trabalho com influencers e acho que seu produto seria perfeito para meu time.',
 CURRENT_TIMESTAMP - INTERVAL '1 day',
 NULL),

-- Instagram - Outbound
('m4444444-4444-4444-4444-444444444444',
 'l6666666-6666-6666-6666-666666666666',
 'instagram',
 'out',
 'Oi Juliana! Muito obrigado pelo feedback! 🎉 Vamos amar trabalhar com você. Que tal agendarmos uma call?',
 CURRENT_TIMESTAMP - INTERVAL '1 day' + INTERVAL '30 minutes',
 '44444444-4444-4444-4444-444444444444'),

-- WhatsApp - Carlos (perfil D - direto)
('m5555555-5555-5555-5555-555555555555',
 'l1111111-1111-1111-1111-111111111111',
 'whatsapp',
 'in',
 'Preciso de solução rápida. Quanto custa e quando posso começar?',
 CURRENT_TIMESTAMP - INTERVAL '4 hours',
 NULL),

('m6666666-6666-6666-6666-666666666666',
 'l1111111-1111-1111-1111-111111111111',
 'whatsapp',
 'out',
 'Carlos, obrigado pelo contato. Investimento entre R$ 15-20k. Podemos começar em 48h após aprovação. Agendei call para terça às 14h para alinharmos os detalhes.',
 CURRENT_TIMESTAMP - INTERVAL '3 hours' + INTERVAL '45 minutes',
 '22222222-2222-2222-2222-222222222222');

-- =====================================================
-- ACTIVITIES (Histórico de ações)
-- =====================================================

INSERT INTO activities (id, lead_id, type, title, description, payload, created_by) VALUES

-- Lead criado
('a1111111-1111-1111-1111-111111111111',
 'l1111111-1111-1111-1111-111111111111',
 'lead_created',
 'Lead criado',
 'Lead Carlos Augusto foi criado no sistema',
 '{"source": "website", "utm_source": "google_ads"}'::jsonb,
 '33333333-3333-3333-3333-333333333333'),

-- Movimentação de estágio
('a2222222-2222-2222-2222-222222222222',
 'l1111111-1111-1111-1111-111111111111',
 'stage_move',
 'Movido para Diagnóstico agendado',
 'Lead movido de "Novo contato" para "Diagnóstico agendado"',
 '{"from_stage": "Novo contato", "to_stage": "Diagnóstico agendado"}'::jsonb,
 '22222222-2222-2222-2222-222222222222'),

-- Nota adicionada
('a3333333-3333-3333-3333-333333333333',
 'l3333333-3333-3333-3333-333333333333',
 'note',
 'Nota adicionada',
 'Cliente gostou muito da apresentação. Pediu 3 dias para avaliar com sócios.',
 '{"note_text": "Cliente gostou muito da apresentação. Pediu 3 dias para avaliar com sócios."}'::jsonb,
 '22222222-2222-2222-2222-222222222222'),

-- Call realizada
('a4444444-4444-4444-4444-444444444444',
 'l6666666-6666-6666-6666-666666666666',
 'call_outcome',
 'Call realizada com sucesso',
 'Call de 45min. Cliente muito interessado. Próximo passo: enviar proposta.',
 '{"outcome": "completed", "duration": "45min", "next_step": "proposta"}'::jsonb,
 '44444444-4444-4444-4444-444444444444'),

-- No-show
('a5555555-5555-5555-5555-555555555555',
 'l2222222-2222-2222-2222-222222222222',
 'call_outcome',
 'No-show na call',
 'Cliente não compareceu ao agendamento',
 '{"outcome": "no_show", "event_id": "e3333333-3333-3333-3333-333333333333"}'::jsonb,
 '22222222-2222-2222-2222-222222222222');

-- =====================================================
-- TASKS (Tarefas pendentes)
-- =====================================================

INSERT INTO tasks (id, lead_id, title, description, due_at, priority, status, assignee_id, created_by) VALUES

-- Task urgente
('t1111111-1111-1111-1111-111111111111',
 'l2222222-2222-2222-2222-222222222222',
 'Reagendar call com Ana Paula',
 'Cliente deu no-show. Tentar reagendamento via WhatsApp.',
 CURRENT_TIMESTAMP + INTERVAL '1 day',
 4,
 'open',
 '22222222-2222-2222-2222-222222222222',
 '22222222-2222-2222-2222-222222222222'),

-- Task normal
('t2222222-2222-2222-2222-222222222222',
 'l3333333-3333-3333-3333-333333333333',
 'Enviar contrato para Roberto',
 'Cliente aprovou proposta verbalmente. Enviar contrato para assinatura.',
 CURRENT_TIMESTAMP + INTERVAL '2 days',
 3,
 'open',
 '22222222-2222-2222-2222-222222222222',
 '22222222-2222-2222-2222-222222222222'),

-- Task concluída
('t3333333-3333-3333-3333-333333333333',
 'l7777777-7777-7777-7777-777777777777',
 'Follow-up pós-venda',
 'Ligar para Paulo para garantir que onboarding está ok',
 CURRENT_TIMESTAMP - INTERVAL '1 day',
 2,
 'done',
 '22222222-2222-2222-2222-222222222222',
 '22222222-2222-2222-2222-222222222222');

-- =====================================================
-- TEMPLATES
-- =====================================================

INSERT INTO templates (id, type, name, description, content, variables, whatsapp_category, approved, created_by) VALUES

-- WhatsApp: Primeiro contato
('tpl11111-1111-1111-1111-111111111111',
 'whatsapp',
 'Primeiro contato',
 'Mensagem inicial de boas-vindas',
 'Olá {{name}}! 👋 Obrigado pelo interesse em nossos serviços. Sou {{user_name}} e vou te ajudar. Qual o melhor horário para conversarmos?',
 '["name", "user_name"]'::jsonb,
 'UTILITY',
 TRUE,
 '11111111-1111-1111-1111-111111111111'),

-- WhatsApp: Reagendamento
('tpl22222-2222-2222-2222-222222222222',
 'whatsapp',
 'Reagendar após no-show',
 'Template para reagendamento quando cliente não aparece',
 'Oi {{name}}, senti sua falta na nossa call de hoje. Imagino que deve ter surgido algo urgente. Podemos reagendar? Quando seria melhor para você? 😊',
 '["name"]'::jsonb,
 'UTILITY',
 TRUE,
 '11111111-1111-1111-1111-111111111111'),

-- Script SPIN: Situação
('tpl33333-3333-3333-3333-333333333333',
 'script',
 'SPIN - Perguntas de Situação',
 'Perguntas para entender contexto do lead',
 'Como está funcionando seu processo atual de [área específica]?\nQuanto tempo você dedica por semana para [tarefa relevante]?\nQuantas pessoas da sua equipe trabalham nisso?',
 '["area_especifica", "tarefa_relevante"]'::jsonb,
 NULL,
 TRUE,
 '11111111-1111-1111-1111-111111111111'),

-- Script SPIN: Problema
('tpl44444-4444-4444-4444-444444444444',
 'script',
 'SPIN - Perguntas de Problema',
 'Identificar dores e desafios',
 'Quais são os principais desafios que você enfrenta hoje?\nO que te impede de alcançar [objetivo]?\nQual o impacto disso no seu dia a dia?',
 '["objetivo"]'::jsonb,
 NULL,
 TRUE,
 '11111111-1111-1111-1111-111111111111');

-- =====================================================
-- NOTIFICATIONS
-- =====================================================

INSERT INTO notifications (id, user_id, title, message, type, action_url, lead_id, read) VALUES

-- Notificação de novo lead
('n1111111-1111-1111-1111-111111111111',
 '22222222-2222-2222-2222-222222222222',
 'Novo lead atribuído',
 'O lead "Thiago Ribeiro" foi atribuído para você.',
 'lead_assigned',
 '/crm?lead=laaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
 'laaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
 FALSE),

-- Notificação de call próxima
('n2222222-2222-2222-2222-222222222222',
 '22222222-2222-2222-2222-222222222222',
 'Call em 2 dias',
 'Você tem uma call agendada com Carlos Augusto em 2 dias.',
 'event_reminder',
 '/crm?lead=l1111111-1111-1111-1111-111111111111',
 'l1111111-1111-1111-1111-111111111111',
 FALSE),

-- Notificação de nova mensagem
('n3333333-3333-3333-3333-333333333333',
 '33333333-3333-3333-3333-333333333333',
 'Nova mensagem no WhatsApp',
 'Thiago Ribeiro enviou uma mensagem.',
 'new_message',
 '/crm?lead=laaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa&tab=messages',
 'laaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
 FALSE);

-- =====================================================
-- FIM DO SEED
-- =====================================================

-- Verificar dados inseridos
SELECT 'Users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'Pipelines', COUNT(*) FROM pipelines
UNION ALL
SELECT 'Stages', COUNT(*) FROM stages
UNION ALL
SELECT 'Leads', COUNT(*) FROM leads
UNION ALL
SELECT 'Events', COUNT(*) FROM events
UNION ALL
SELECT 'Messages', COUNT(*) FROM messages
UNION ALL
SELECT 'Activities', COUNT(*) FROM activities
UNION ALL
SELECT 'Tasks', COUNT(*) FROM tasks
UNION ALL
SELECT 'Templates', COUNT(*) FROM templates
UNION ALL
SELECT 'Notifications', COUNT(*) FROM notifications;
