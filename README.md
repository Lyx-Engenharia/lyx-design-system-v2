# Lyx Design System v2

Sistema de design unificado Lyx — tokens 52W + components + layout pronto. Instalação única para projetos novos e existentes.

## Stack

- Next.js 16 (App Router) + React 19 + TypeScript 5
- Tailwind CSS 4 (inline `@theme`)
- Inter (next/font/google) + Geist Mono
- Radix UI (via pacote `radix-ui`) + CVA + Lucide
- TanStack Query 5 + Sonner (toasts) + React Hook Form + Zod 4
- Recharts 3
- Better Auth (opcional)

## Conteúdo

```
lyx-design-system-v2/
├── apply-lyx-front.sh           ← instalador para projetos existentes
├── tokens/
│   └── globals.css              ← OKLCH light/dark + classes 52W
├── app/
│   ├── root-layout.tsx          ← root com fonts + Providers
│   ├── login/page.tsx           ← login form pronto
│   └── dashboard/
│       └── layout.tsx           ← sidebar + topbar 52W
├── components/
│   ├── providers.tsx            ← TanStack Query + Sonner
│   ├── theme-toggle.tsx
│   ├── lyx-modal.tsx            ← modal com Portal + ESC
│   └── ui/                      ← button, card, badge, input, label,
│                                  textarea, select, dialog, skeleton,
│                                  separator, table, lyx-logo, sidebar
├── lib/
│   ├── utils.ts                 ← cn() helper
│   ├── api.ts                   ← fetch wrapper credentials
│   ├── auth-client.ts           ← Better Auth client + org plugin
│   └── queries.ts               ← TanStack hooks padrão
└── assets/
    └── lyx-logo.svg/.png
```

## Uso

### Projeto novo

Use o template Git complementar:

```bash
npx degit Lyx-Engenharia/lyx-front-template meu-novo-sistema
cd meu-novo-sistema && npm install && npm run dev
```

### Projeto existente

Aplica DS sobreposto no Next existente:

```bash
# Clona o DS
git clone <repo>/lyx-design-system-v2 /tmp/lyx-ds
# Aplica
bash /tmp/lyx-ds/apply-lyx-front.sh ~/Projetos/meu-front
```

Flags:

| Flag | Default | Efeito |
|---|---|---|
| `--no-dashboard` | off | Pula `/dashboard` + `/login`, instala só tokens + components |
| `--with-auth` | off | Inclui Better Auth client + lib/auth-client.ts |
| `--no-auth` | on | Sem deps Better Auth |

## O que ele instala

1. **Deps** (npm install):
   - Base: `class-variance-authority`, `clsx`, `tailwind-merge`, `tw-animate-css`, `lucide-react`, `radix-ui`, `zod`
   - Dashboard: `@tanstack/react-query`, `sonner`, `recharts`, `react-hook-form`, `@hookform/resolvers`
   - Auth: `better-auth`

2. **Arquivos**:
   - `app/globals.css` (substitui) — tokens + classes `.app-shell`, `.sidebar`, `.nav-item`, `.page-header`, `.page-body`, `.lyx-card`, `.stat-card`, `.btn`, `.form-*`, `.lyx-badge`, `.lyx-modal`, `.lyx-table`
   - `app/layout.tsx` (substitui) — Inter + Geist Mono + Providers
   - `app/dashboard/layout.tsx` (cria) — sidebar com sections + topbar com greeting/search/bell/avatar
   - `app/login/page.tsx` (cria) — login pronto consumindo Better Auth
   - `components/ui/*` — Button, Card, Badge, Input, Label, Textarea, Select, Dialog, Skeleton, Separator, Table, LyxLogo, Sidebar
   - `components/providers.tsx`, `lyx-modal.tsx`, `theme-toggle.tsx`
   - `lib/utils.ts`, `api.ts`, `queries.ts`, `auth-client.ts`
   - `public/lyx-logo.svg` + `.png`

## Customizar após instalar

| O quê | Onde |
|---|---|
| Cor accent (`#025864`) | `app/globals.css` linha `:root { --accent: ... }` |
| Logo SVG topo sidebar | `app/dashboard/layout.tsx` (inline `<svg>` 3 retângulos) |
| Brand text "LyxHub / ENTREGAS" | mesmo arquivo |
| Nav items | array `navOperacional` / `navAdmin` |
| Greeting | função `greeting()` |
| Dark mode default | localStorage `theme` |

## Convenções (alinhadas com monolith Lyx)

- Cliente API consome `NEXT_PUBLIC_API_URL` (monolith)
- Cookies cross-subdomain via `credentials: 'include'`
- Org ativa via Better Auth `setActive`
- Layout app-shell: sidebar fixa 260px + main scroll
- Tokens nominais Tailwind 4 (`bg-card`, `text-muted-foreground`) mapeiam vars Lyx (`--bg-card`, `--text-muted`)
- Classes nominais 52W disponíveis (`btn`, `lyx-card`, `stat-card`, `form-input`)

## Versão

v2 — paleta 52W teal `#025864` + dark `[data-theme='dark']`
