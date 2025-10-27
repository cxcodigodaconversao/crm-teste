# 🚀 CRM Conversão - Sistema Completo de Gestão de Leads

Sistema de CRM moderno focado em conversão, com pipeline Kanban, integração com Google Calendar, WhatsApp Business API oficial e Instagram DMs.

## 📋 Índice

1. [Features](#features)
2. [Tech Stack](#tech-stack)
3. [Pré-requisitos](#pré-requisitos)
4. [Instalação](#instalação)
5. [Configuração de APIs](#configuração-de-apis)
6. [Desenvolvimento](#desenvolvimento)
7. [Deploy](#deploy)
8. [Estrutura do Projeto](#estrutura-do-projeto)
9. [Testes](#testes)
10. [Troubleshooting](#troubleshooting)

---

## ✨ Features

### Core CRM
- ✅ **Pipeline Kanban** com drag & drop
- ✅ **Perfis DISC** com cores e tooltips informativos
- ✅ **Lead scoring** com IA/ML
- ✅ **Timeline de atividades** completo
- ✅ **Tags e campos customizáveis**
- ✅ **Busca avançada** e filtros

### Integrações
- ✅ **Google Calendar** (OAuth 2.0 + webhooks)
- ✅ **WhatsApp Business API** oficial (360dialog/Twilio/WATI)
- ✅ **Instagram DMs** (Graph API)
- ✅ **Email** (SMTP/SendGrid)
- ⏳ **Zoom** (opcional)

### Automações
- ✅ **Workflows automáticos** por estágio
- ✅ **Follow-ups inteligentes**
- ✅ **Detecção de no-show**
- ✅ **Rotação round-robin** de leads
- ✅ **Alertas de inatividade** (>7 dias)

### Analytics
- ✅ **Dashboard com KPIs** (win rate, show rate, TME)
- ✅ **Funil de conversão** visual
- ✅ **Relatórios por período** e owner
- ✅ **Métricas por canal** (WhatsApp, Instagram, etc)

### UX/UI
- ✅ **Real-time updates** (WebSockets)
- ✅ **Notificações** in-app e push
- ✅ **Atalhos de teclado**
- ✅ **Tema dark** profissional
- ✅ **Mobile responsive**

### Segurança & Compliance
- ✅ **RBAC** (Admin, Closer, SDR, Viewer)
- ✅ **Audit log** completo
- ✅ **LGPD** compliance
- ✅ **Criptografia** de dados sensíveis

---

## 🛠️ Tech Stack

### Frontend
- **Next.js 14** (App Router)
- **TypeScript**
- **Tailwind CSS** + **shadcn/ui**
- **Zustand** (state management)
- **@hello-pangea/dnd** (drag & drop)
- **Recharts** (gráficos)
- **Socket.io-client** (real-time)

### Backend
- **Fastify** (Node.js framework)
- **TypeScript**
- **PostgreSQL 14+** (Supabase)
- **Redis** (cache + queue)
- **BullMQ** (background jobs)
- **Socket.io** (WebSocket server)

### Integrações
- **Google APIs** (Calendar)
- **Meta APIs** (WhatsApp, Instagram)
- **Twilio/360dialog** (WhatsApp providers)

### DevOps
- **Docker** + **Docker Compose**
- **Vercel** (frontend) / **Railway** (backend)
- **GitHub Actions** (CI/CD)

---

## 📦 Pré-requisitos

- **Node.js** >= 18.x
- **PostgreSQL** >= 14.x
- **Redis** >= 6.x
- **Docker** (opcional, recomendado)
- Conta **Google Cloud** (para Calendar API)
- Conta **Meta for Developers** (para Instagram)
- Conta **360dialog/Twilio/WATI** (para WhatsApp)

---

## 🚀 Instalação

### 1. Clone o repositório

```bash
git clone https://github.com/seu-usuario/crm-conversao.git
cd crm-conversao
```

### 2. Instale as dependências

```bash
# Frontend (Next.js)
npm install

# Backend (Fastify)
cd backend
npm install
cd ..
```

### 3. Configure as variáveis de ambiente

```bash
# Copie o arquivo de exemplo
cp .env.example .env.local

# Edite o arquivo e preencha com suas credenciais
nano .env.local
```

### 4. Setup do banco de dados

**Opção A: Docker (recomendado)**

```bash
docker-compose up -d postgres redis
```

**Opção B: Instalação local**

```bash
# PostgreSQL
createdb crm_conversao

# Rode as migrations
psql crm_conversao < database/schema.sql

# Popule com dados de teste
psql crm_conversao < database/seeds/seed-demo-data.sql
```

### 5. Inicie os servidores

```bash
# Terminal 1: Frontend
npm run dev

# Terminal 2: Backend
cd backend
npm run dev
```

Acesse: `http://localhost:3000`

---

## 🔑 Configuração de APIs

### Google Calendar

1. Acesse https://console.cloud.google.com/
2. Crie um novo projeto
3. Ative a **Google Calendar API**
4. Vá em **Credenciais** → **Criar credenciais** → **ID do cliente OAuth 2.0**
5. Configure:
   - **Tipo**: Aplicativo da Web
   - **URIs autorizados**: `http://localhost:3000`, `https://seu-dominio.com`
   - **URIs de redirecionamento**: `http://localhost:3000/api/auth/google/callback`
6. Copie **Client ID** e **Client Secret** para `.env.local`:
   ```env
   GOOGLE_CLIENT_ID="..."
   GOOGLE_CLIENT_SECRET="..."
   ```

**Webhooks (Notificações Push)**

```bash
# Registrar canal (rode após deploy)
curl -X POST \
  https://seu-dominio.com/api/calendar/watch \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### WhatsApp Business API

#### Opção 1: 360dialog (Recomendado)

1. Acesse https://www.360dialog.com/
2. Crie uma conta e conecte seu número comercial
3. Configure o webhook:
   - URL: `https://seu-dominio.com/api/webhooks/whatsapp`
   - Eventos: `messages`, `message_status`
4. Copie as credenciais para `.env.local`:
   ```env
   WABA_PROVIDER="360dialog"
   WABA_API_KEY="..."
   WABA_CLIENT_ID="..."
   WABA_PHONE_NUMBER_ID="+5531999999999"
   WABA_WEBHOOK_VERIFY_TOKEN="seu-token-aleatorio"
   ```

**Criar templates aprovados:**

```bash
# Via 360dialog dashboard
# Categorias: UTILITY (transacional), MARKETING (promocional)
```

#### Opção 2: Twilio

1. Acesse https://console.twilio.com/
2. Configure WhatsApp no Messaging → Try WhatsApp
3. Copie credenciais:
   ```env
   WABA_PROVIDER="twilio"
   TWILIO_ACCOUNT_SID="..."
   TWILIO_AUTH_TOKEN="..."
   TWILIO_WHATSAPP_NUMBER="+14155238886"
   ```

### Instagram Graph API

1. Acesse https://developers.facebook.com/apps/
2. Crie um novo app → Tipo: **Business**
3. Adicione os produtos:
   - **Instagram**
   - **Messenger**
4. Configure:
   - Vincule conta Instagram **Business** a uma Página Facebook
   - Adicione permissões: `instagram_basic`, `instagram_manage_messages`, `pages_messaging`
5. Gere token de longa duração:
   ```bash
   curl -X GET "https://graph.facebook.com/v18.0/oauth/access_token?grant_type=fb_exchange_token&client_id=SEU_APP_ID&client_secret=SEU_SECRET&fb_exchange_token=TOKEN_CURTO"
   ```
6. Configure webhook:
   - URL: `https://seu-dominio.com/api/webhooks/instagram`
   - Subscrições: `messages`, `messaging_postbacks`
7. Copie para `.env.local`:
   ```env
   IG_APP_ID="..."
   IG_APP_SECRET="..."
   IG_PAGE_ACCESS_TOKEN="..."
   IG_WEBHOOK_SECRET="seu-secret-aleatorio"
   ```

---

## 💻 Desenvolvimento

### Scripts disponíveis

```bash
# Frontend
npm run dev          # Inicia servidor dev (porta 3000)
npm run build        # Build para produção
npm run start        # Inicia servidor produção
npm run lint         # Roda ESLint
npm run type-check   # Verifica tipos TypeScript

# Backend
cd backend
npm run dev          # Inicia servidor dev (porta 3001)
npm run build        # Compila TypeScript
npm run start        # Inicia servidor produção
npm run test         # Roda testes
```

### Estrutura de branches

```
main         → Produção (protegida)
staging      → Homologação
develop      → Desenvolvimento
feature/*    → Features
bugfix/*     → Correções
hotfix/*     → Correções urgentes
```

### Commit Convention

```bash
feat: Nova feature
fix: Correção de bug
docs: Documentação
style: Formatação
refactor: Refatoração
test: Testes
chore: Manutenção
```

### Atalhos de teclado (frontend)

- `A` → Agendar call
- `N` → Adicionar nota
- `T` → Criar tarefa
- `R` → Responder mensagem
- `/` → Buscar leads
- `Ctrl+K` → Command palette

---

## 🌐 Deploy

### Frontend (Vercel)

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel --prod

# Configure variáveis de ambiente no dashboard
# vercel.com/your-project/settings/environment-variables
```

### Backend (Railway)

```bash
# Install Railway CLI
npm i -g @railway/cli

# Login
railway login

# Deploy
railway up

# Configure variáveis de ambiente
railway vars set VARIABLE=valor
```

**Alternativa: Render**

```bash
# Crie conta em render.com
# Conecte repo GitHub
# Configure:
# - Build Command: cd backend && npm install && npm run build
# - Start Command: cd backend && npm run start
```

### Banco de Dados (Supabase)

1. Acesse https://supabase.com/
2. Crie novo projeto
3. Vá em SQL Editor
4. Cole e execute `database/schema.sql`
5. Cole e execute `database/seeds/seed-demo-data.sql` (opcional)
6. Copie connection string:
   ```env
   DATABASE_URL="postgresql://postgres:[PASSWORD]@[HOST]:5432/postgres"
   ```

### Redis (Upstash)

1. Acesse https://upstash.com/
2. Crie banco Redis
3. Copie URL:
   ```env
   REDIS_URL="rediss://default:xxxxx@us1-xxxxx.upstash.io:6379"
   ```

### Webhooks

⚠️ **IMPORTANTE**: URLs de webhook DEVEM ser públicas e HTTPS.

**Configurar domínio:**

```bash
# Após deploy, obtenha URL pública:
# Frontend: https://crm-conversao.vercel.app
# Backend: https://crm-api.railway.app

# Configure as URLs de webhook:
WEBHOOK_GOOGLE_URL="https://crm-api.railway.app/api/webhooks/google"
WEBHOOK_WHATSAPP_URL="https://crm-api.railway.app/api/webhooks/whatsapp"
WEBHOOK_INSTAGRAM_URL="https://crm-api.railway.app/api/webhooks/instagram"
```

**Testar webhooks:**

```bash
# ngrok (para desenvolvimento)
ngrok http 3001

# Use a URL do ngrok para testar localmente
```

---

## 📁 Estrutura do Projeto

```
crm-conversao/
├── app/                    # Next.js App Router
│   ├── (auth)/            # Rotas de autenticação
│   ├── (dashboard)/
│   │   └── crm/           # ⭐ ABA CRM PRINCIPAL
│   │       ├── page.tsx
│   │       ├── components/
│   │       └── hooks/
│   └── api/               # API Routes (Next.js)
├── backend/               # Fastify Backend
│   ├── src/
│   │   ├── modules/       # Features (leads, messages, etc)
│   │   ├── integrations/  # APIs externas
│   │   └── workers/       # Background jobs
│   └── package.json
├── database/
│   ├── schema.sql         # Schema PostgreSQL
│   ├── migrations/
│   └── seeds/
├── components/            # Componentes React
├── lib/                   # Utils e stores
├── public/
├── .env.example
└── README.md
```

---

## 🧪 Testes

### Frontend

```bash
npm run test          # Roda testes unitários (Jest)
npm run test:e2e      # Testes E2E (Playwright)
npm run test:coverage # Cobertura de código
```

### Backend

```bash
cd backend
npm run test          # Testes unitários
npm run test:int      # Testes de integração
npm run test:load     # Testes de carga (K6)
```

### Testes de webhooks

```bash
# Simular webhook do WhatsApp
curl -X POST http://localhost:3001/api/webhooks/whatsapp \
  -H "Content-Type: application/json" \
  -d '{"messages": [{"from": "+5531999999999", "text": {"body": "Teste"}}]}'

# Simular webhook do Instagram
curl -X POST http://localhost:3001/api/webhooks/instagram \
  -H "Content-Type: application/json" \
  -d '{"entry": [{"messaging": [{"sender": {"id": "123"}, "message": {"text": "Teste"}}]}]}'
```

---

## 🐛 Troubleshooting

### Erro: "Cannot connect to PostgreSQL"

**Solução:**
```bash
# Verifique se PostgreSQL está rodando
docker ps | grep postgres

# Ou
pg_isready

# Teste conexão
psql -h localhost -p 5432 -U postgres -d crm_conversao
```

### Erro: "Google OAuth redirect_uri_mismatch"

**Solução:**
1. Vá no Google Cloud Console
2. Credenciais → Seu OAuth Client
3. Adicione EXATAMENTE a URI que está aparecendo no erro
4. Aguarde 5 minutos para propagar

### Erro: "WhatsApp template not approved"

**Solução:**
1. Templates levam 24-48h para aprovação
2. Use templates de teste fornecidos pelo provedor
3. Verifique categoria (UTILITY vs MARKETING)

### Erro: "Instagram webhook verification failed"

**Solução:**
```bash
# Verifique se o token de verificação está correto
# No código do webhook, deve haver algo como:

if (req.query['hub.verify_token'] === process.env.IG_WEBHOOK_SECRET) {
  return res.send(req.query['hub.challenge']);
}
```

### Performance: Kanban lento com muitos leads

**Solução:**
```bash
# Habilitar virtualização
# Em Kanban.tsx, use react-window:
npm install react-window

# Ou adicione paginação por estágio
```

---

## 📊 Métricas e Monitoramento

### Sentry (Error Tracking)

```bash
npm install @sentry/nextjs @sentry/node

# Configure SENTRY_DSN no .env
```

### Analytics

```bash
# Google Analytics
NEXT_PUBLIC_GA_ID="G-XXXXXXXXXX"

# Posthog (alternativa open-source)
npm install posthog-js
```

---

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'feat: Add AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

---

## 🆘 Suporte

- 📧 Email: suporte@crmconversao.com
- 💬 Discord: [discord.gg/crmconversao](https://discord.gg/)
- 📚 Docs: [docs.crmconversao.com](https://docs.crmconversao.com)

---

## 🎯 Roadmap

- [x] Pipeline Kanban básico
- [x] Integração Google Calendar
- [x] WhatsApp Business API
- [x] Instagram DMs
- [x] Dashboard analytics
- [ ] IA para lead scoring
- [ ] Automação avançada (workflows visuais)
- [ ] Mobile app (React Native)
- [ ] API pública com webhooks
- [ ] Marketplace de integrações

---

**Desenvolvido com ❤️ para conversão real, sem romantização.**
