# 🧪 GUIA DE TESTES LOCAIS

## ✅ Checklist Pré-teste

Antes de testar, verifique:

- [ ] Node.js >= 18.0.0 instalado (`node -v`)
- [ ] PostgreSQL instalado e rodando (`pg_isready`)
- [ ] Redis instalado (opcional) (`redis-cli ping`)
- [ ] Git instalado (`git --version`)

---

## 🚀 Setup Rápido (5 minutos)

### 1. Criar projeto Next.js

```bash
# Criar projeto
npx create-next-app@latest crm-conversao --typescript --tailwind --app

cd crm-conversao

# Responda as perguntas:
# ✔ Would you like to use ESLint? → Yes
# ✔ Would you like to use `src/` directory? → No
# ✔ Would you like to use App Router? → Yes
# ✔ Would you like to customize the default import alias? → No
```

### 2. Instalar dependências extras

```bash
npm install @hello-pangea/dnd zustand date-fns lucide-react
npm install @radix-ui/react-dialog @radix-ui/react-dropdown-menu @radix-ui/react-select
npm install recharts socket.io-client axios
npm install class-variance-authority clsx tailwind-merge tailwindcss-animate
```

### 3. Criar estrutura de pastas

```bash
# Windows (PowerShell)
New-Item -ItemType Directory -Path "app\(dashboard)\crm\components" -Force
New-Item -ItemType Directory -Path "database\seeds" -Force
New-Item -ItemType Directory -Path "demo" -Force
New-Item -ItemType Directory -Path "docs" -Force
New-Item -ItemType Directory -Path "types" -Force

# Linux/Mac
mkdir -p "app/(dashboard)/crm/components"
mkdir -p database/seeds
mkdir -p demo
mkdir -p docs
mkdir -p types
```

### 4. Copiar arquivos baixados

```bash
# IMPORTANTE: Baixe todos os arquivos do projeto primeiro!

# Arquivos de configuração
cp .gitignore .
cp .env.example .env.local
cp package.json . # merge com o existente
cp next.config.js .
cp tailwind.config.ts .
cp tsconfig.json .
cp LICENSE .

# Componentes React
cp Kanban.tsx "app/(dashboard)/crm/components/"
cp LeadCard.tsx "app/(dashboard)/crm/components/"
cp DISCBadge.tsx "app/(dashboard)/crm/components/"

# Types
cp types-crm.ts types/crm.ts

# Database
cp schema.sql database/
cp seed-demo-data.sql database/seeds/

# Demo
cp demo-crm-interativa.html demo/index.html

# Documentação
cp RESUMO_EXECUTIVO.md docs/
cp GUIA_IMPLEMENTACAO_CRM.md docs/
cp GUIA_VISUAL_DEMO.md docs/
cp ESTRUTURA_GITHUB.md docs/
```

### 5. Configurar .env.local

```bash
# Abra o arquivo .env.local e preencha o mínimo:
DATABASE_URL="postgresql://postgres:password@localhost:5432/crm_conversao"
NEXTAUTH_SECRET="seu-secret-aqui-min-32-chars"
NEXTAUTH_URL="http://localhost:3000"
```

### 6. Setup banco de dados

```bash
# Criar banco
createdb crm_conversao

# OU via psql
psql -U postgres
CREATE DATABASE crm_conversao;
\q

# Rodar migrations
psql -U postgres -d crm_conversao -f database/schema.sql

# Seed dados de teste
psql -U postgres -d crm_conversao -f database/seeds/seed-demo-data.sql

# Verificar
psql -U postgres -d crm_conversao -c "SELECT COUNT(*) FROM leads;"
```

### 7. Instalar dependências (novamente, para garantir)

```bash
npm install
```

### 8. Rodar o projeto

```bash
npm run dev
```

### 9. Abrir no navegador

```
http://localhost:3000
```

---

## 🧪 Testes Funcionais

### Teste 1: Página inicial carrega

```bash
# Deve abrir sem erros no console
# Deve mostrar "404" ou "Welcome" (normal, pois não temos página raiz ainda)
```

### Teste 2: Demo HTML funciona

```bash
# Abra o arquivo demo/index.html diretamente no navegador
# Ou via:
npx serve demo
# Acesse http://localhost:3000

# ✅ Deve mostrar:
# - Header com estatísticas
# - 6 colunas do Kanban
# - 9 leads com badges DISC
# - Legenda DISC flutuante
# - Clique nos cards mostra notificação
# - Hover nos badges DISC mostra tooltip
```

### Teste 3: Banco de dados populado

```bash
psql -U postgres -d crm_conversao

# Rodar queries de teste:
SELECT COUNT(*) FROM users;      -- Deve retornar 4
SELECT COUNT(*) FROM leads;      -- Deve retornar 10
SELECT COUNT(*) FROM stages;     -- Deve retornar 12
SELECT COUNT(*) FROM events;     -- Deve retornar 3
SELECT COUNT(*) FROM messages;   -- Deve retornar 6

# Ver leads com stats
SELECT name, stage_name, deal_value, disc_profile 
FROM leads_with_stats 
WHERE deleted_at IS NULL
ORDER BY created_at DESC;

\q
```

### Teste 4: Componentes importam sem erro

```bash
# Crie um arquivo de teste: app/(dashboard)/crm/page.tsx

cat > "app/(dashboard)/crm/page.tsx" << 'EOF'
import { Kanban } from './components/Kanban';

export default function CRMPage() {
  return (
    <div className="h-screen">
      <Kanban 
        pipelineId="aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa" 
        userId="22222222-2222-2222-2222-222222222222"
        userRole="admin"
      />
    </div>
  );
}
EOF

# Agora acesse: http://localhost:3000/crm
# Vai dar erro de API ainda, mas o componente deve importar
```

---

## 🔧 Troubleshooting

### Erro: "Cannot find module '@/types/crm'"

```bash
# Solução: Verifique o tsconfig.json
# Deve ter:
"paths": {
  "@/*": ["./*"],
  "@/types/*": ["./types/*"]
}

# Reinicie o servidor
npm run dev
```

### Erro: "Module not found: Can't resolve 'lucide-react'"

```bash
# Instale a dependência
npm install lucide-react
```

### Erro: "Cannot connect to database"

```bash
# Verifique se PostgreSQL está rodando
pg_isready

# Windows: Abra o Services e inicie "postgresql-x64-XX"
# Linux: sudo systemctl start postgresql
# Mac: brew services start postgresql
```

### Erro: "Tailwind classes not working"

```bash
# Verifique se tailwind.config.ts existe
# Verifique se app/globals.css tem:
@tailwind base;
@tailwind components;
@tailwind utilities;

# Reinicie o servidor
npm run dev
```

### Erro: Database "crm_conversao" does not exist

```bash
# Crie o banco
createdb crm_conversao

# OU
psql -U postgres -c "CREATE DATABASE crm_conversao;"
```

---

## ✅ Checklist de Verificação

Depois de tudo configurado, verifique:

- [ ] `npm run dev` inicia sem erros
- [ ] `http://localhost:3000` abre
- [ ] Demo HTML (`demo/index.html`) funciona
- [ ] Banco tem 10 leads (`SELECT COUNT(*) FROM leads;`)
- [ ] TypeScript compila sem erros (`npm run build`)
- [ ] Componentes importam corretamente

---

## 📊 Próximos Passos (Desenvolvimento)

Agora que tudo está funcionando localmente, você pode:

1. **Criar página CRM** (`app/(dashboard)/crm/page.tsx`)
2. **Implementar API routes** (`app/api/leads/route.ts`)
3. **Configurar autenticação** (NextAuth.js)
4. **Integrar APIs externas** (Google, WhatsApp, Instagram)
5. **Deploy em staging** (Vercel)

---

## 🎯 Scripts Úteis

```bash
# Desenvolvimento
npm run dev              # Inicia servidor dev

# Build
npm run build            # Build para produção
npm run start            # Inicia servidor produção

# Linting & Formatação
npm run lint             # ESLint
npm run type-check       # TypeScript check

# Database
npm run db:migrate       # Roda migrations
npm run db:seed          # Seed dados

# Testes (quando implementados)
npm test                 # Jest
npm run test:watch       # Jest watch mode
npm run test:e2e         # Playwright
```

---

## 📝 Comandos Rápidos de Debug

```bash
# Ver todas as variáveis de ambiente
cat .env.local

# Ver tabelas do banco
psql -U postgres -d crm_conversao -c "\dt"

# Ver último lead criado
psql -U postgres -d crm_conversao -c "SELECT * FROM leads ORDER BY created_at DESC LIMIT 1;"

# Limpar cache do Next.js
rm -rf .next

# Reinstalar dependências
rm -rf node_modules package-lock.json
npm install

# Ver portas em uso (Linux/Mac)
lsof -i :3000

# Windows
netstat -ano | findstr :3000
```

---

## 🎉 Sucesso!

Se chegou até aqui e tudo está funcionando, parabéns! 🎊

**Próximo passo:** Siga o [Guia de Implementação](docs/GUIA_IMPLEMENTACAO_CRM.md) para conectar as APIs reais.

---

**Dúvidas?** Abra uma issue no GitHub ou consulte a [documentação completa](docs/).
