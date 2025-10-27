# 🚀 GUIA COMPLETO DE IMPLEMENTAÇÃO - CRM CONVERSÃO

## 📋 ÍNDICE
1. [Obtenção de APIs e Credenciais](#apis)
2. [Arquitetura e Melhorias Sugeridas](#arquitetura)
3. [Setup do Projeto](#setup)
4. [Estrutura de Pastas](#estrutura)
5. [Implementação Passo a Passo](#implementacao)
6. [Testes e Deploy](#testes)

---

## 🔑 1. OBTENÇÃO DE APIs E CREDENCIAIS {#apis}

### 1.1 Google Calendar API

**Onde obter:**
- Console: https://console.cloud.google.com/

**Passos:**
1. Acesse o Google Cloud Console
2. Crie um novo projeto ou selecione existente
3. Vá em "APIs e Serviços" → "Biblioteca"
4. Busque e ative:
   - Google Calendar API
   - Google People API (para dados do usuário)
5. Vá em "Credenciais" → "Criar credenciais" → "ID do cliente OAuth 2.0"
6. Configure a tela de consentimento:
   - Tipo: Externo (se não for Workspace)
   - Escopos necessários:
     ```
     https://www.googleapis.com/auth/calendar
     https://www.googleapis.com/auth/calendar.events
     https://www.googleapis.com/auth/userinfo.email
     https://www.googleapis.com/auth/userinfo.profile
     ```
7. Crie as credenciais OAuth:
   - Tipo de aplicativo: Aplicativo da Web
   - URIs de redirecionamento autorizados:
     ```
     http://localhost:3000/api/auth/google/callback (dev)
     https://seu-dominio.com/api/auth/google/callback (prod)
     ```
8. Anote:
   - `GOOGLE_CLIENT_ID`
   - `GOOGLE_CLIENT_SECRET`

**Webhooks (Push Notifications):**
1. Na mesma página de APIs, configure:
   - Domain verification em https://console.cloud.google.com/apis/credentials/domainverification
2. Endpoint webhook: `https://seu-dominio.com/api/webhooks/google`
3. Registre o canal via código (implementado no backend)

**Custos:** Gratuito até 1 milhão de requisições/dia

---

### 1.2 WhatsApp Business API (WABA)

**IMPORTANTE:** Não use WhatsApp pessoal. Use apenas API oficial.

#### Opção 1: Meta (360dialog) - RECOMENDADO
**Onde obter:**
- Site: https://www.360dialog.com/
- Pricing: A partir de €49/mês + custo por conversa

**Passos:**
1. Crie conta no 360dialog
2. Conecte seu número de telefone (precisa ser número comercial)
3. Verifique o número via SMS/chamada
4. Configure o perfil de negócio (nome, logo, descrição)
5. Obtenha as credenciais:
   - `WABA_API_KEY` (Partner API Key)
   - `WABA_CLIENT_ID`
   - `WABA_PHONE_NUMBER_ID`
6. Configure webhook:
   - URL: `https://seu-dominio.com/api/webhooks/whatsapp`
   - Eventos: messages, message_status
   - Anote o `WEBHOOK_VERIFY_TOKEN` (você cria)

**Templates:**
- Crie templates no painel 360dialog
- Aguarde aprovação Meta (24-48h)
- Categorias: UTILITY, MARKETING, AUTHENTICATION

#### Opção 2: Twilio
**Onde obter:**
- Site: https://www.twilio.com/whatsapp
- Pricing: Pay-as-you-go

**Passos:**
1. Crie conta Twilio
2. Vá em Messaging → Try it out → Try WhatsApp
3. Configure número Twilio para WhatsApp
4. Credenciais:
   - `TWILIO_ACCOUNT_SID`
   - `TWILIO_AUTH_TOKEN`
   - `TWILIO_WHATSAPP_NUMBER`
5. Webhook: Configure em Messaging → Settings → WhatsApp Sandbox

#### Opção 3: WATI
**Onde obter:**
- Site: https://www.wati.io/
- Pricing: A partir de $39/mês

**Mais simples, mas menos customizável.**

**Custo por conversa (Meta):**
- Marketing: $0.0275 - $0.0660 (Brasil)
- Utility: $0.0085 - $0.0210 (Brasil)
- Session (24h): Primeira mensagem inicia, depois free por 24h

---

### 1.3 Instagram Graph API (DMs)

**Onde obter:**
- Meta for Developers: https://developers.facebook.com/

**Passos:**
1. Acesse https://developers.facebook.com/apps/
2. Crie um novo app → Tipo: Business
3. Adicione produto "Instagram"
4. Configure:
   - Vá em Instagram → Basic Display
   - Adicione sua conta Instagram Business
   - Vincule a uma Página do Facebook
5. Adicione produto "Messenger" (necessário para DMs)
6. Permissões necessárias:
   ```
   instagram_basic
   instagram_manage_messages
   instagram_manage_comments
   pages_manage_metadata
   pages_messaging
   ```
7. Obtenha credenciais:
   - `IG_APP_ID`
   - `IG_APP_SECRET`
   - `IG_PAGE_ACCESS_TOKEN` (gerado via Graph API Explorer)
8. Configure webhook:
   - URL: `https://seu-dominio.com/api/webhooks/instagram`
   - Subscrições: messages, messaging_postbacks
   - Anote `IG_WEBHOOK_SECRET`

**Requisitos:**
- ✅ Conta Instagram BUSINESS (não Creator)
- ✅ Vinculada a Página Facebook
- ✅ App aprovado pela Meta (submeta para review)

**Custos:** Gratuito (sujeito a rate limits)

**Rate Limits:**
- 200 chamadas/hora por usuário
- 4800 chamadas/dia por app

---

## 🏗️ 2. ARQUITETURA E MELHORIAS SUGERIDAS {#arquitetura}

### Melhorias Identificadas:

#### ✅ Adicionadas:
1. **Real-time Updates:** WebSockets (Socket.io) para:
   - Atualizações de Kanban em tempo real (múltiplos usuários)
   - Notificações de novas mensagens
   - Alertas de calls próximas

2. **Sistema de Notificações Internas:**
   - Bell icon com contador
   - Push notifications (Web Push API)
   - Email digest diário

3. **IA/ML Features:**
   - Sugestão automática de DISC baseada em análise de texto
   - Lead scoring preditivo (probabilidade de conversão)
   - Melhor horário para follow-up (baseado em histórico)

4. **Automações Avançadas:**
   - Workflows visuais (quando X → fazer Y)
   - Sequências de follow-up automáticas
   - Rotação automática de leads (round-robin)

5. **Performance:**
   - Redis para cache (listas Kanban, dashboards)
   - Elasticsearch para busca avançada de leads
   - CDN para assets estáticos

6. **Backup & Disaster Recovery:**
   - Backup automático diário do PostgreSQL
   - Replicação para região secundária
   - Point-in-time recovery

7. **Compliance LGPD:**
   - Módulo de consentimento explícito
   - Anonimização de dados
   - Exportação de dados do lead
   - Direito ao esquecimento (delete cascade)

### Arquitetura Final:

```
┌─────────────────────────────────────────────────────────┐
│                     FRONTEND (Next.js)                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐             │
│  │  Kanban  │  │  Inbox   │  │Dashboard │             │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘             │
└───────┼─────────────┼─────────────┼───────────────────┘
        │             │             │
        │    WebSocket (Socket.io)  │
        │             │             │
┌───────┼─────────────┼─────────────┼───────────────────┐
│       │     REST API (Fastify)    │                   │
│  ┌────▼─────┐  ┌────▼─────┐  ┌───▼──────┐           │
│  │  Leads   │  │Messages  │  │Analytics │           │
│  │ Service  │  │ Service  │  │ Service  │           │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘           │
│       │             │              │                  │
│  ┌────▼─────────────▼──────────────▼─────┐           │
│  │         PostgreSQL (Supabase)          │           │
│  └────────────────────────────────────────┘           │
│                                                        │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐     │
│  │   Redis    │  │  BullMQ    │  │Elasticsearch│     │
│  │  (Cache)   │  │  (Queue)   │  │  (Search)   │     │
│  └────────────┘  └────────────┘  └────────────┘     │
└────────────────────────────────────────────────────────┘
        │                │                 │
┌───────▼────────┐ ┌─────▼──────┐ ┌───────▼────────┐
│  Google Cal    │ │ WhatsApp   │ │  Instagram     │
│  API           │ │ Business   │ │  Graph API     │
└────────────────┘ └────────────┘ └────────────────┘
```

---

## 🛠️ 3. SETUP DO PROJETO {#setup}

### 3.1 Arquivo .env (Environment Variables)

Crie `.env.local` na raiz:

```env
# Database
DATABASE_URL="postgresql://user:password@localhost:5432/crm_conversao"
DIRECT_URL="postgresql://user:password@localhost:5432/crm_conversao"

# Redis
REDIS_URL="redis://localhost:6379"

# Authentication
JWT_SECRET="seu-secret-super-seguro-aqui-min-32-chars"
JWT_EXPIRES_IN="7d"
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET="outro-secret-super-seguro-min-32-chars"

# Google Calendar
GOOGLE_CLIENT_ID="123456789-xxxxxxxxxxxxx.apps.googleusercontent.com"
GOOGLE_CLIENT_SECRET="GOCSPX-xxxxxxxxxxxxxxxxxx"
GOOGLE_REDIRECT_URI="http://localhost:3000/api/auth/google/callback"

# WhatsApp Business API (360dialog exemplo)
WABA_PROVIDER="360dialog"  # ou "twilio" ou "wati"
WABA_API_KEY="your-360dialog-api-key"
WABA_CLIENT_ID="your-client-id"
WABA_PHONE_NUMBER_ID="+5531999999999"
WABA_WEBHOOK_VERIFY_TOKEN="seu-token-verificacao-aleatorio"

# Twilio (se usar)
TWILIO_ACCOUNT_SID=""
TWILIO_AUTH_TOKEN=""
TWILIO_WHATSAPP_NUMBER=""

# Instagram
IG_APP_ID="your-instagram-app-id"
IG_APP_SECRET="your-instagram-app-secret"
IG_PAGE_ACCESS_TOKEN="your-long-lived-page-access-token"
IG_WEBHOOK_SECRET="seu-webhook-secret-aleatorio"

# Webhook Security
WEBHOOK_SECRET="master-webhook-secret-min-32-chars"

# Email (opcional - para notificações)
SMTP_HOST="smtp.gmail.com"
SMTP_PORT="587"
SMTP_USER="seu-email@gmail.com"
SMTP_PASSWORD="sua-senha-app"

# Monitoring (opcional)
SENTRY_DSN=""
LOG_LEVEL="info"

# Feature Flags
ENABLE_WEBSOCKETS="true"
ENABLE_AI_SCORING="true"
ENABLE_ELASTICSEARCH="false"
```

### 3.2 Comandos de Instalação

```bash
# Clone ou crie o projeto
npx create-next-app@latest crm-conversao --typescript --tailwind --app

cd crm-conversao

# Dependências Frontend
npm install @hello-pangea/dnd zustand date-fns lucide-react
npm install @radix-ui/react-dialog @radix-ui/react-dropdown-menu @radix-ui/react-select
npm install recharts socket.io-client
npm install class-variance-authority clsx tailwind-merge

# Dependências Backend
npm install fastify @fastify/cors @fastify/jwt @fastify/multipart
npm install pg drizzle-orm drizzle-kit
npm install bullmq ioredis
npm install socket.io
npm install googleapis
npm install axios

# Dev Dependencies
npm install -D @types/node tsx nodemon
npm install -D prisma  # se preferir Prisma ao Drizzle

# Opcional (melhorias)
npm install @elastic/elasticsearch  # se usar Elasticsearch
npm install ai openai  # para features de IA
```

---

## 📁 4. ESTRUTURA DE PASTAS {#estrutura}

```
crm-conversao/
├── app/                          # Next.js 14 App Router
│   ├── (auth)/
│   │   ├── login/
│   │   └── oauth/
│   │       └── google/
│   │           └── callback/
│   ├── (dashboard)/
│   │   ├── layout.tsx
│   │   ├── crm/                 # ⭐ ABA CRM PRINCIPAL
│   │   │   ├── page.tsx
│   │   │   ├── components/
│   │   │   │   ├── Kanban.tsx
│   │   │   │   ├── LeadCard.tsx
│   │   │   │   ├── LeadSidebar.tsx
│   │   │   │   ├── InboxUnified.tsx
│   │   │   │   ├── MessageThread.tsx
│   │   │   │   ├── ScheduleModal.tsx
│   │   │   │   ├── CallOutcomeModal.tsx
│   │   │   │   └── DISCBadge.tsx
│   │   │   └── hooks/
│   │   │       ├── useKanban.ts
│   │   │       ├── useMessages.ts
│   │   │       └── useCalendar.ts
│   │   ├── dashboard/
│   │   ├── settings/
│   │   │   ├── integrations/
│   │   │   ├── pipelines/
│   │   │   └── templates/
│   │   └── tasks/
│   └── api/                      # API Routes (Next.js)
│       ├── auth/
│       ├── leads/
│       ├── messages/
│       ├── events/
│       ├── webhooks/
│       │   ├── google/
│       │   ├── whatsapp/
│       │   └── instagram/
│       └── dashboard/
├── backend/                      # Fastify Backend (standalone)
│   ├── src/
│   │   ├── server.ts
│   │   ├── config/
│   │   │   ├── database.ts
│   │   │   ├── redis.ts
│   │   │   └── integrations.ts
│   │   ├── modules/
│   │   │   ├── leads/
│   │   │   │   ├── leads.controller.ts
│   │   │   │   ├── leads.service.ts
│   │   │   │   ├── leads.repository.ts
│   │   │   │   └── leads.schema.ts
│   │   │   ├── messages/
│   │   │   ├── events/
│   │   │   ├── activities/
│   │   │   └── auth/
│   │   ├── integrations/
│   │   │   ├── google-calendar/
│   │   │   │   ├── calendar.service.ts
│   │   │   │   └── calendar.webhooks.ts
│   │   │   ├── whatsapp/
│   │   │   │   ├── 360dialog.provider.ts
│   │   │   │   ├── twilio.provider.ts
│   │   │   │   ├── waba.service.ts
│   │   │   │   └── webhooks.ts
│   │   │   └── instagram/
│   │   │       ├── graph.service.ts
│   │   │       └── webhooks.ts
│   │   ├── workers/              # Background Jobs (BullMQ)
│   │   │   ├── message-processor.ts
│   │   │   ├── calendar-sync.ts
│   │   │   └── notifications.ts
│   │   ├── websocket/
│   │   │   └── socket-server.ts
│   │   └── utils/
│   │       ├── logger.ts
│   │       └── error-handler.ts
│   └── package.json
├── database/
│   ├── schema.sql                # Schema PostgreSQL
│   ├── migrations/
│   └── seeds/
│       └── seed-demo-data.ts
├── lib/
│   ├── store/                    # Zustand stores
│   │   ├── kanban-store.ts
│   │   ├── messages-store.ts
│   │   └── auth-store.ts
│   ├── api-client.ts
│   └── utils.ts
├── components/
│   ├── ui/                       # shadcn/ui components
│   └── shared/
├── public/
├── .env.local
├── .env.example
├── package.json
├── tsconfig.json
├── tailwind.config.ts
├── next.config.js
└── README.md
```

---

## 💻 5. IMPLEMENTAÇÃO PASSO A PASSO {#implementacao}

### Passo 1: Database Schema
Ver arquivo `schema.sql` (será criado)

### Passo 2: Backend API
Ver arquivos em `/backend/src/`

### Passo 3: Frontend Components
Ver arquivos em `/app/(dashboard)/crm/`

### Passo 4: Integrações
- Google Calendar: OAuth + Webhooks
- WhatsApp: Provider pattern (360dialog/Twilio)
- Instagram: Graph API + DM webhook

### Passo 5: WebSockets
- Real-time Kanban updates
- Message notifications

### Passo 6: Dashboard & Analytics
- Recharts para gráficos
- KPIs calculados via SQL otimizado

---

## 🧪 6. TESTES E DEPLOY {#testes}

### Testes Unitários
```bash
npm test
```

### Testes de Integração
- Webhook simulators
- Mock das APIs externas

### Deploy
1. **Frontend (Vercel):**
   ```bash
   vercel --prod
   ```

2. **Backend (Railway/Render):**
   ```bash
   # Railway
   railway up
   
   # ou Render
   render deploy
   ```

3. **Database (Supabase):**
   - Use o painel Supabase
   - Rode migrations via SQL Editor

4. **Redis (Upstash):**
   - Plano gratuito: 10k comandos/dia

---

## 📊 CUSTOS ESTIMADOS (MVP)

| Serviço | Custo/mês | Notas |
|---------|-----------|-------|
| Vercel (Frontend) | $0 | Hobby plan |
| Railway (Backend) | $5 | 500h/mês |
| Supabase (DB) | $0 | Free tier (500MB) |
| Upstash (Redis) | $0 | Free tier |
| 360dialog (WhatsApp) | €49 | + €0.027/conversa |
| Google Calendar | $0 | Gratuito |
| Instagram API | $0 | Gratuito |
| **TOTAL BASE** | **~$60/mês** | Escalável conforme uso |

---

## 🚦 PRÓXIMOS PASSOS

1. ✅ Obter todas as credenciais de API (seguir seções 1.1-1.3)
2. ✅ Criar projeto e instalar dependências
3. ✅ Configurar .env com todas as chaves
4. ✅ Rodar migrations no banco
5. ✅ Implementar backend (APIs + webhooks)
6. ✅ Implementar frontend (Kanban + Inbox)
7. ✅ Testar integrações uma a uma
8. ✅ Deploy staging
9. ✅ Testes de carga
10. ✅ Deploy produção

---

**Importante:** Guarde este documento como referência durante todo o desenvolvimento!
