# 🎯 CRM Conversão

> Sistema de CRM moderno focado em conversão real, com pipeline Kanban, perfis DISC, e integrações nativas com Google Calendar, WhatsApp Business API e Instagram DMs.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.0-blue.svg)](https://www.typescriptlang.org/)
[![Next.js](https://img.shields.io/badge/Next.js-14-black.svg)](https://nextjs.org/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

## ✨ Features

### 🎨 Interface
- ✅ **Kanban interativo** com drag & drop ([@hello-pangea/dnd](https://github.com/hello-pangea/dnd))
- ✅ **Perfis DISC** com tooltips informativos e sugestão automática
- ✅ **Real-time updates** via WebSocket
- ✅ **Dashboard analytics** com gráficos e KPIs
- ✅ **Tema dark** profissional e moderno

### 🔗 Integrações
- ✅ **Google Calendar** - Agendamento automático com webhooks
- ✅ **WhatsApp Business API** - Mensagens via 360dialog/Twilio
- ✅ **Instagram DMs** - Graph API para direct messages
- ✅ **Email** - Notificações e templates

### 🤖 Automações
- ✅ **Lead scoring com IA** - Priorização automática
- ✅ **Workflows customizáveis** - Ações automáticas por estágio
- ✅ **Detecção de no-show** - Alerta e follow-up automático
- ✅ **Rotação round-robin** - Distribuição justa de leads

### 📊 Analytics
- ✅ **Win rate**, **Show rate**, **TME** (Tempo Médio de Estágio)
- ✅ **Funil de conversão** visual
- ✅ **Relatórios por período** e owner
- ✅ **Métricas por canal** (WhatsApp, Instagram, etc)

---

## 🚀 Quick Start

### 📋 Pré-requisitos

- Node.js >= 18.0.0
- PostgreSQL >= 14.x
- Redis >= 6.x (opcional para cache)
- Contas: Google Cloud, Meta (Facebook/Instagram), 360dialog/Twilio

### 🛠️ Instalação

```bash
# 1. Clone o repositório
git clone https://github.com/seu-usuario/crm-conversao.git
cd crm-conversao

# 2. Instale dependências
npm install

# 3. Configure variáveis de ambiente
cp .env.example .env.local
# Edite .env.local com suas credenciais

# 4. Setup banco de dados
psql seu_banco < database/schema.sql
psql seu_banco < database/seeds/seed-demo-data.sql

# 5. Rode o projeto
npm run dev
```

Acesse: **http://localhost:3000**

---

## 🎨 Demo Interativa

[**🎥 Ver Demo Funcionando →**](demo/index.html)

![CRM Demo](https://via.placeholder.com/800x400/0c121c/d2bc8f?text=CRM+Conversão+Demo)

A demo inclui:
- 9 leads fictícios com todos os perfis DISC
- Kanban funcional com 6 estágios
- Badges interativos com tooltips
- Indicadores visuais (mensagens, tarefas, alertas)
- AI Score com barra de progresso

---

## 📖 Documentação

- **[Guia de Implementação](docs/GUIA_IMPLEMENTACAO_CRM.md)** - Como obter APIs e implementar
- **[Resumo Executivo](docs/RESUMO_EXECUTIVO.md)** - Visão geral e checklist
- **[Estrutura GitHub](docs/ESTRUTURA_GITHUB.md)** - Organização do repositório
- **[Guia Visual](docs/GUIA_VISUAL_DEMO.md)** - Recursos da interface

---

## 🗄️ Tech Stack

### Frontend
- **Next.js 14** (App Router)
- **TypeScript**
- **Tailwind CSS** + **shadcn/ui**
- **Zustand** (state management)
- **@hello-pangea/dnd** (drag & drop)
- **Recharts** (gráficos)
- **Socket.io** (real-time)

### Backend
- **Fastify** (Node.js framework)
- **PostgreSQL** (Supabase)
- **Redis** (cache + queue)
- **BullMQ** (jobs)
- **Socket.io** (WebSocket)

### Integrações
- **Google Calendar API**
- **WhatsApp Business API** (360dialog/Twilio)
- **Instagram Graph API**
- **SendGrid/SMTP** (email)

---

## 🏗️ Arquitetura

```
┌─────────────────────────────────────────────────────────┐
│                  FRONTEND (Next.js)                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐             │
│  │  Kanban  │  │  Inbox   │  │Dashboard │             │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘             │
└───────┼─────────────┼─────────────┼───────────────────┘
        │    WebSocket (Socket.io)  │
┌───────┼─────────────┼─────────────┼───────────────────┐
│       │     REST API (Fastify)    │                   │
│  ┌────▼─────┐  ┌────▼─────┐  ┌───▼──────┐           │
│  │  Leads   │  │Messages  │  │Analytics │           │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘           │
│  ┌────▼─────────────▼──────────────▼─────┐           │
│  │      PostgreSQL + Redis + BullMQ       │           │
│  └────────────────────────────────────────┘           │
└────────────────────────────────────────────────────────┘
        │                │                 │
┌───────▼────────┐ ┌─────▼──────┐ ┌───────▼────────┐
│  Google Cal    │ │ WhatsApp   │ │  Instagram     │
└────────────────┘ └────────────┘ └────────────────┘
```

---

## 🗂️ Estrutura do Projeto

```
crm-conversao/
├── app/                    # Next.js App Router
│   ├── (dashboard)/crm/   # ⭐ Aba CRM principal
│   └── api/               # API Routes
├── components/            # Componentes React
├── database/              # SQL schemas e seeds
├── demo/                  # Demo HTML interativa
├── docs/                  # Documentação completa
├── lib/                   # Utilities e stores
├── types/                 # TypeScript types
├── .env.example           # Template de variáveis
└── package.json           # Dependências
```

---

## 🔐 Configuração de APIs

### 1. Google Calendar

1. Acesse [Google Cloud Console](https://console.cloud.google.com/)
2. Crie projeto → Ative Calendar API
3. OAuth 2.0 → Copie Client ID e Secret
4. Configure no `.env.local`:

```env
GOOGLE_CLIENT_ID="your-client-id"
GOOGLE_CLIENT_SECRET="your-client-secret"
```

### 2. WhatsApp Business API

**Opção A: 360dialog** (Recomendado)

1. Acesse [360dialog](https://www.360dialog.com/)
2. Conecte número comercial
3. Configure webhook
4. Copie API Key

**Opção B: Twilio**

1. Acesse [Twilio Console](https://console.twilio.com/)
2. Configure WhatsApp Sandbox
3. Copie credenciais

### 3. Instagram Graph API

1. Acesse [Meta for Developers](https://developers.facebook.com/)
2. Crie app → Adicione Instagram + Messenger
3. Gere token de longa duração
4. Configure webhook

**[📖 Guia detalhado de APIs →](docs/GUIA_IMPLEMENTACAO_CRM.md)**

---

## 📊 Database Schema

O projeto usa PostgreSQL com 13 tabelas principais:

- `users` - Usuários do sistema
- `pipelines` - Pipelines de vendas
- `stages` - Estágios do Kanban
- `leads` - Leads/Contatos
- `events` - Agendamentos (Google Calendar)
- `messages` - WhatsApp + Instagram DMs
- `activities` - Audit log
- `tasks` - Tarefas e follow-ups
- `integrations` - Conexões externas
- `templates` - Templates de mensagens
- `notifications` - Sistema de notificações
- `webhooks_log` - Log de webhooks
- E mais...

[Ver schema completo →](database/schema.sql)

---

## 🧪 Testes

```bash
# Testes unitários
npm test

# Testes E2E
npm run test:e2e

# Coverage
npm run test:coverage
```

---

## 🚢 Deploy

### Vercel (Frontend)

```bash
vercel --prod
```

### Railway (Backend)

```bash
railway up
```

### Supabase (Database)

1. Crie projeto no [Supabase](https://supabase.com/)
2. Execute `schema.sql` no SQL Editor
3. Copie connection string

[Guia completo de deploy →](docs/GUIA_IMPLEMENTACAO_CRM.md#deploy)

---

## 💰 Custos Estimados

| Serviço | Custo/mês | Notas |
|---------|-----------|-------|
| Vercel | $0 | Hobby plan |
| Railway | $5 | Starter |
| Supabase | $0 | Free tier |
| 360dialog | €49 | + €0.027/conversa |
| **TOTAL** | **~$60** | Escalável |

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Por favor:

1. Fork o projeto
2. Crie uma branch: `git checkout -b feature/AmazingFeature`
3. Commit: `git commit -m 'feat: Add AmazingFeature'`
4. Push: `git push origin feature/AmazingFeature`
5. Abra um Pull Request

[Código de Conduta →](CODE_OF_CONDUCT.md)

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja [LICENSE](LICENSE) para mais detalhes.

---

## 🙏 Agradecimentos

- [Next.js](https://nextjs.org/) - Framework React
- [Tailwind CSS](https://tailwindcss.com/) - Styling
- [@hello-pangea/dnd](https://github.com/hello-pangea/dnd) - Drag & drop
- [shadcn/ui](https://ui.shadcn.com/) - Componentes
- [Supabase](https://supabase.com/) - Database & Auth

---

## 📞 Suporte

- 📧 Email: suporte@crmconversao.com
- 💬 Discord: [discord.gg/crmconversao](https://discord.gg/)
- 📚 Docs: [docs.crmconversao.com](https://docs.crmconversao.com)

---

## 🗺️ Roadmap

- [x] Pipeline Kanban básico
- [x] Integração Google Calendar
- [x] WhatsApp Business API
- [x] Instagram DMs
- [x] Dashboard analytics
- [ ] IA para lead scoring avançado
- [ ] Automação visual (workflows)
- [ ] Mobile app (React Native)
- [ ] API pública
- [ ] Marketplace de integrações

---

**Desenvolvido com ❤️ para conversão real, sem romantização.**

**[⭐ Star no GitHub](https://github.com/seu-usuario/crm-conversao)** se este projeto te ajudou!
