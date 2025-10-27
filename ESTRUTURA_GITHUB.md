# 📁 ESTRUTURA DE PASTAS - GITHUB

## 🎯 Como Organizar o Repositório

```
crm-conversao/
│
├── .github/                          # GitHub workflows (opcional)
│   └── workflows/
│       └── ci.yml                    # CI/CD (opcional)
│
├── app/                              # Next.js App Router
│   ├── (auth)/
│   │   └── login/
│   │       └── page.tsx
│   ├── (dashboard)/
│   │   ├── layout.tsx
│   │   └── crm/
│   │       ├── page.tsx
│   │       └── components/
│   │           ├── Kanban.tsx       # ✅ COPIAR
│   │           ├── LeadCard.tsx     # ✅ COPIAR
│   │           └── DISCBadge.tsx    # ✅ COPIAR
│   └── api/
│       └── leads/
│           └── route.ts
│
├── backend/                          # Backend separado (Fastify)
│   ├── src/
│   │   ├── server.ts
│   │   ├── modules/
│   │   └── integrations/
│   └── package.json
│
├── components/                       # Componentes compartilhados
│   └── ui/
│
├── database/                         # ✅ IMPORTANTE
│   ├── schema.sql                   # ✅ COPIAR
│   └── seeds/
│       └── seed-demo-data.sql       # ✅ COPIAR
│
├── demo/                             # Demos e exemplos
│   └── crm-interativa.html          # ✅ COPIAR (renomear)
│
├── docs/                             # ✅ Documentação
│   ├── GUIA_IMPLEMENTACAO_CRM.md    # ✅ COPIAR
│   ├── GUIA_VISUAL_DEMO.md          # ✅ COPIAR
│   └── RESUMO_EXECUTIVO.md          # ✅ COPIAR
│
├── lib/                              # Utilities
│   └── store/
│
├── public/                           # Assets estáticos
│   └── images/
│
├── types/                            # TypeScript types
│   └── crm.ts                       # ✅ COPIAR (renomear types-crm.ts)
│
├── .env.example                      # ✅ COPIAR
├── .gitignore                        # ✅ CRIAR (já criado)
├── LICENSE                           # ✅ CRIAR
├── package.json                      # ✅ COPIAR
├── README.md                         # ✅ COPIAR
├── tailwind.config.ts                # ✅ CRIAR
├── tsconfig.json                     # ✅ CRIAR
└── next.config.js                    # ✅ CRIAR
```

---

## ✅ CHECKLIST DE ARQUIVOS

### 📄 INCLUIR (commitar no Git)

- [x] `.gitignore`
- [x] `README.md`
- [x] `package.json`
- [x] `.env.example`
- [x] `LICENSE` (opcional)
- [x] Todos os `.md` em `/docs/`
- [x] `schema.sql` e `seed-demo-data.sql`
- [x] Todos os componentes `.tsx` e `.ts`
- [x] `types/crm.ts`
- [x] `demo/crm-interativa.html`
- [x] Arquivos de config: `tsconfig.json`, `next.config.js`, `tailwind.config.ts`

### ❌ EXCLUIR (NÃO commitar)

- [ ] `.env`
- [ ] `.env.local`
- [ ] `node_modules/`
- [ ] `.next/`
- [ ] `dist/`
- [ ] `build/`
- [ ] Qualquer arquivo com credenciais reais
- [ ] `*.log`
- [ ] `.DS_Store`

---

## 🚀 PASSOS PARA SUBIR NO GITHUB

### 1. Criar estrutura de pastas local

```bash
# Criar projeto Next.js
npx create-next-app@latest crm-conversao --typescript --tailwind --app

cd crm-conversao

# Criar pastas
mkdir -p app/\(dashboard\)/crm/components
mkdir -p backend/src
mkdir -p database/seeds
mkdir -p demo
mkdir -p docs
mkdir -p types
```

### 2. Copiar arquivos do projeto

```bash
# Documentação
cp RESUMO_EXECUTIVO.md docs/
cp GUIA_IMPLEMENTACAO_CRM.md docs/
cp GUIA_VISUAL_DEMO.md docs/
cp COMO_ABRIR_DEMO.md docs/
cp INDEX.md docs/

# Código
cp Kanban.tsx app/\(dashboard\)/crm/components/
cp LeadCard.tsx app/\(dashboard\)/crm/components/
cp DISCBadge.tsx app/\(dashboard\)/crm/components/
cp types-crm.ts types/crm.ts

# Database
cp schema.sql database/
cp seed-demo-data.sql database/seeds/

# Demo
cp demo-crm-interativa.html demo/index.html

# Config
cp .env.example .
cp package.json .
cp .gitignore .
```

### 3. Inicializar Git

```bash
git init
git add .
git commit -m "feat: initial commit - CRM Conversão"
```

### 4. Criar repositório no GitHub

1. Acesse https://github.com/new
2. Nome: `crm-conversao`
3. Descrição: `Sistema de CRM focado em conversão com Kanban, Google Calendar, WhatsApp e Instagram`
4. Público ou Privado (você escolhe)
5. NÃO inicialize com README (já temos)

### 5. Push para GitHub

```bash
git remote add origin https://github.com/SEU_USUARIO/crm-conversao.git
git branch -M main
git push -u origin main
```

---

## 📝 ARQUIVOS DE CONFIGURAÇÃO NECESSÁRIOS

### tsconfig.json
Será criado automaticamente pelo Next.js, mas pode precisar de ajustes.

### next.config.js
```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
};

module.exports = nextConfig;
```

### tailwind.config.ts
```typescript
import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        'crm-dark': '#0c121c',
        'crm-medium': '#1a2332',
        'crm-light': '#2a3441',
        'crm-accent': '#d2bc8f',
      },
    },
  },
  plugins: [],
}
export default config
```

---

## 🔐 SEGURANÇA

### ⚠️ NUNCA commitar:

1. Credenciais reais (tokens, secrets, passwords)
2. Arquivo `.env` ou `.env.local`
3. `node_modules/`
4. Arquivos de build
5. Logs com informações sensíveis

### ✅ Sempre commitar:

1. `.env.example` (com valores fake/placeholder)
2. Documentação
3. Código fonte
4. Testes
5. Schemas de banco (sem dados reais)

---

## 📦 O QUE VAI PARA O REPOSITÓRIO

```
crm-conversao/
├── 📁 app/               → Código Next.js
├── 📁 components/        → Componentes React
├── 📁 database/          → SQL schemas
├── 📁 demo/              → Demo HTML
├── 📁 docs/              → Toda documentação
├── 📁 lib/               → Utilities
├── 📁 public/            → Assets estáticos
├── 📁 types/             → TypeScript types
├── 📄 .env.example       → Template de env vars
├── 📄 .gitignore         → Arquivos ignorados
├── 📄 LICENSE            → Licença (MIT sugerido)
├── 📄 package.json       → Dependências
├── 📄 README.md          → Documentação principal
├── 📄 next.config.js     → Config Next.js
├── 📄 tailwind.config.ts → Config Tailwind
└── 📄 tsconfig.json      → Config TypeScript
```

**Tamanho estimado:** ~50-100 MB (sem node_modules)

---

## 🎯 PRÓXIMOS PASSOS

Após subir no GitHub:

1. ✅ Adicionar badges no README (build, license, version)
2. ✅ Configurar GitHub Actions (CI/CD) - opcional
3. ✅ Adicionar CONTRIBUTING.md - se for open source
4. ✅ Criar GitHub Projects/Issues para tarefas
5. ✅ Configurar proteção de branch `main`
6. ✅ Adicionar descrição e topics no repo

---

**Pronto! Com isso você terá um repositório profissional e bem organizado! 🚀**
