#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  Lyx Design System v2 — instalação única
#  Aplica tokens + components + layout dashboard 52W em projeto Next.js existente.
#  Uso: bash apply-lyx-front.sh <caminho-do-projeto> [--with-auth] [--with-dashboard]
# ─────────────────────────────────────────────────────────────
set -e

DS_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="$1"
WITH_AUTH=false
WITH_DASH=true

shift || true
for arg in "$@"; do
  case "$arg" in
    --no-dashboard) WITH_DASH=false ;;
    --no-auth)      WITH_AUTH=false ;;
    --with-auth)    WITH_AUTH=true ;;
  esac
done

# ── Validações ───────────────────────────────────────────────
if [ -z "$TARGET" ]; then
  echo "Uso: bash apply-lyx-front.sh <caminho-do-projeto> [--no-dashboard] [--with-auth]"
  exit 1
fi
[ ! -d "$TARGET" ] && { echo "Erro: pasta '$TARGET' não encontrada"; exit 1; }
[ ! -f "$TARGET/package.json" ] && { echo "Erro: '$TARGET' não é Node project"; exit 1; }
grep -q '"next"' "$TARGET/package.json" || { echo "Erro: '$TARGET' não usa Next.js"; exit 1; }
command -v npm >/dev/null || { echo "Erro: npm não encontrado"; exit 1; }

if [ -d "$TARGET/src/app" ]; then
  APP_DIR="$TARGET/src/app"; COMP="$TARGET/src/components"; LIB="$TARGET/src/lib"
elif [ -d "$TARGET/app" ]; then
  APP_DIR="$TARGET/app"; COMP="$TARGET/components"; LIB="$TARGET/lib"
else
  echo "Erro: App Router não encontrado (espera 'app/' ou 'src/app/')"; exit 1
fi

echo "▶ Aplicando Lyx DS v2 em: $TARGET"
echo "  App router: $APP_DIR"
echo "  Dashboard:  $WITH_DASH | Auth: $WITH_AUTH"
echo ""

# ── 1. Deps ──────────────────────────────────────────────────
echo "[1/5] Instalando dependências..."
DEPS="class-variance-authority clsx tailwind-merge tw-animate-css lucide-react radix-ui zod"
[ "$WITH_DASH" = true ] && DEPS="$DEPS @tanstack/react-query sonner recharts react-hook-form @hookform/resolvers"
[ "$WITH_AUTH" = true ] && DEPS="$DEPS better-auth"
( cd "$TARGET" && npm install $DEPS 2>&1 | tail -3 )

# ── 2. Tokens ────────────────────────────────────────────────
echo "[2/5] Copiando tokens (globals.css)..."
cp "$DS_DIR/tokens/globals.css" "$APP_DIR/globals.css"

# ── 3. Components + lib ──────────────────────────────────────
echo "[3/5] Copiando components/ui + helpers..."
mkdir -p "$COMP/ui" "$LIB" "$TARGET/public"
cp -r "$DS_DIR/components/ui/"*.tsx "$COMP/ui/"
cp "$DS_DIR/components/lyx-modal.tsx" "$COMP/"
cp "$DS_DIR/components/theme-toggle.tsx" "$COMP/"
cp "$DS_DIR/lib/utils.ts" "$LIB/"
[ "$WITH_DASH" = true ] && {
  cp "$DS_DIR/components/providers.tsx" "$COMP/"
  cp "$DS_DIR/lib/api.ts" "$LIB/" 2>/dev/null || true
  cp "$DS_DIR/lib/queries.ts" "$LIB/" 2>/dev/null || true
}
[ "$WITH_AUTH" = true ] && {
  cp "$DS_DIR/lib/auth-client.ts" "$LIB/" 2>/dev/null || true
}
[ -f "$DS_DIR/assets/lyx-logo.svg" ] && cp "$DS_DIR/assets/lyx-logo.svg" "$TARGET/public/"
[ -f "$DS_DIR/assets/lyx-logo.png" ] && cp "$DS_DIR/assets/lyx-logo.png" "$TARGET/public/"

# ── 4. Root layout (fonts + providers) ───────────────────────
echo "[4/5] Atualizando layout.tsx root..."
ROOT_LAYOUT="$APP_DIR/layout.tsx"
if [ -f "$ROOT_LAYOUT" ]; then
  cp "$DS_DIR/app/root-layout.tsx" "$ROOT_LAYOUT"
  echo "      ✓ root layout substituído"
fi

# ── 5. Dashboard layout opcional ─────────────────────────────
if [ "$WITH_DASH" = true ]; then
  echo "[5/5] Copiando dashboard layout..."
  mkdir -p "$APP_DIR/dashboard"
  cp "$DS_DIR/app/dashboard/layout.tsx" "$APP_DIR/dashboard/layout.tsx"
  cp "$DS_DIR/app/login/page.tsx" "$APP_DIR/login/page.tsx" 2>/dev/null || {
    mkdir -p "$APP_DIR/login"
    cp "$DS_DIR/app/login/page.tsx" "$APP_DIR/login/page.tsx"
  }
  echo "      ✓ /dashboard + /login criados"
else
  echo "[5/5] Skip dashboard (--no-dashboard)"
fi

echo ""
echo "✓ Lyx DS v2 aplicado!"
echo ""
echo "Próximos passos:"
echo "  cd $TARGET"
echo "  cp .env.example .env  # se aplicável"
echo "  npm run dev"
echo ""
echo "Customizar:"
echo "  - tokens (cores/spacing): $APP_DIR/globals.css"
echo "  - nav items: $APP_DIR/dashboard/layout.tsx"
echo "  - logo: $TARGET/public/lyx-logo.svg"
