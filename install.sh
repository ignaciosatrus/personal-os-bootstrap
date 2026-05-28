#!/usr/bin/env bash
#
# Personal OS Bootstrap — installer
#
# Crea un OS personal en ~/[slug]-os/ a partir de este template.
# Lo configura para que escribiendo el slug del operador en una
# terminal nueva, se abra Claude Code en la carpeta del OS.
#
# Uso:
#   bash install.sh
#
set -euo pipefail

# ---- Colores (sobreviven a terminales que no soportan tput)
if command -v tput >/dev/null 2>&1 && [ -t 1 ]; then
    BOLD=$(tput bold); DIM=$(tput dim); RESET=$(tput sgr0)
    GREEN=$(tput setaf 2); YELLOW=$(tput setaf 3); RED=$(tput setaf 1); BLUE=$(tput setaf 4)
else
    BOLD=""; DIM=""; RESET=""; GREEN=""; YELLOW=""; RED=""; BLUE=""
fi

say()  { printf "%s\n" "$*"; }
ok()   { printf "%s✓%s %s\n" "$GREEN" "$RESET" "$*"; }
warn() { printf "%s!%s %s\n" "$YELLOW" "$RESET" "$*"; }
err()  { printf "%s✗%s %s\n" "$RED" "$RESET" "$*" >&2; }
hl()   { printf "%s%s%s\n" "$BOLD" "$*" "$RESET"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

say ""
hl "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
hl "  Personal OS Bootstrap"
hl "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
say ""
say "Esto NO es una configuración técnica."
say "Es el primer acto de un sistema que aprenderá cómo trabajas."
say ""
say "Voy a:"
say "  1. Preguntarte tu nombre y un slug corto (cómo lo invocarás)"
say "  2. Crear ~/[slug]-os/ con el esqueleto del OS"
say "  3. Instalar Claude Code si no lo tienes"
say "  4. Añadir un alias para que escribir tu slug abra el OS"
say ""
say "${DIM}La sesión real de identidad la harás luego, dentro de Claude Code.${RESET}"
say ""

# ---- 1. Recoger nombre y slug
read -rp "$(hl 'Tu nombre (como te llamas)'): " OPERATOR_NAME
if [ -z "${OPERATOR_NAME// }" ]; then
    err "El nombre no puede estar vacío."
    exit 1
fi

DEFAULT_SLUG=$(printf "%s" "$OPERATOR_NAME" \
    | tr '[:upper:]' '[:lower:]' \
    | iconv -t ASCII//TRANSLIT 2>/dev/null \
    | tr -cs 'a-z0-9' '-' \
    | sed -E 's/^-+|-+$//g' \
    || true)
DEFAULT_SLUG=${DEFAULT_SLUG:-$(printf "%s" "$OPERATOR_NAME" | tr '[:upper:] ' '[:lower:]-' | tr -cd 'a-z0-9-')}

read -rp "$(hl 'Slug corto') ${DIM}(comando que abrirá el OS — solo a-z, 0-9, guiones)${RESET} [$DEFAULT_SLUG]: " OPERATOR_SLUG
OPERATOR_SLUG=${OPERATOR_SLUG:-$DEFAULT_SLUG}

if ! printf "%s" "$OPERATOR_SLUG" | grep -Eq '^[a-z][a-z0-9-]*$'; then
    err "Slug inválido. Debe empezar por letra y contener sólo a-z, 0-9, guiones."
    exit 1
fi

TARGET="$HOME/${OPERATOR_SLUG}-os"

say ""
say "Crearé: ${BOLD}${TARGET}${RESET}"
say "Alias:  escribir ${BOLD}${OPERATOR_SLUG}${RESET} en una terminal abrirá Claude Code ahí"
say ""
read -rp "¿Procedemos? [Y/n] " CONFIRM
CONFIRM=${CONFIRM:-Y}
if [[ ! "$CONFIRM" =~ ^[YySs]$ ]]; then
    say "Abortando. Nada se ha tocado."
    exit 0
fi

# ---- 2. Comprobar destino
if [ -e "$TARGET" ]; then
    warn "${TARGET} ya existe."
    read -rp "¿Sobreescribir? Esto BORRA su contenido actual. [y/N] " OVERWRITE
    if [[ ! "$OVERWRITE" =~ ^[YySs]$ ]]; then
        say "Cancelado. Elige otro slug o mueve el directorio antes."
        exit 0
    fi
    rm -rf "$TARGET"
fi

# ---- 3. Copiar template
mkdir -p "$TARGET"
# Copiar todo excepto los archivos sólo-template
(cd "$SCRIPT_DIR" && \
    find . -mindepth 1 -maxdepth 1 \
        ! -name '.git' \
        ! -name 'install.sh' \
        ! -name 'email-template.md' \
        ! -name 'README.md' \
        -exec cp -R {} "$TARGET/" \;)
ok "Esqueleto copiado a ${TARGET}"

# Asegurar permisos de ejecución de scripts (cp -R debería preservarlos,
# pero algunos filesystems / configuraciones los pierden)
if [ -d "$TARGET/scripts" ]; then
    find "$TARGET/scripts" -type f -name '*.sh' -exec chmod +x {} \;
fi

# ---- 4. Sustituir placeholders
# Detectar sed -i flavor (GNU vs BSD)
if sed --version >/dev/null 2>&1; then
    SED_INPLACE=(sed -i)
else
    SED_INPLACE=(sed -i '')
fi

# Escapar para sed
esc() { printf '%s' "$1" | sed -e 's/[\/&]/\\&/g'; }
ESC_NAME=$(esc "$OPERATOR_NAME")
ESC_SLUG=$(esc "$OPERATOR_SLUG")

find "$TARGET" -type f \( -name '*.md' -o -name '*.json' -o -name '*.sh' \) -print0 \
    | while IFS= read -r -d '' f; do
        "${SED_INPLACE[@]}" -e "s/{{OPERATOR_NAME}}/${ESC_NAME}/g" \
                            -e "s/{{OPERATOR_SLUG}}/${ESC_SLUG}/g" "$f"
    done
ok "Placeholders sustituidos"

# ---- 5. Claude Code
if command -v claude >/dev/null 2>&1; then
    ok "Claude Code ya instalado: $(claude --version 2>/dev/null | head -n1 || echo "ok")"
else
    warn "Claude Code no está instalado."
    if command -v npm >/dev/null 2>&1; then
        read -rp "¿Lo instalo ahora con npm? [Y/n] " INSTALL_CC
        INSTALL_CC=${INSTALL_CC:-Y}
        if [[ "$INSTALL_CC" =~ ^[YySs]$ ]]; then
            say ""
            say "${DIM}Ejecutando: npm install -g @anthropic-ai/claude-code${RESET}"
            if npm install -g @anthropic-ai/claude-code; then
                ok "Claude Code instalado"
            else
                err "Falló la instalación. Instala manualmente: npm install -g @anthropic-ai/claude-code"
            fi
        else
            warn "Salto la instalación. Instálalo después con: npm install -g @anthropic-ai/claude-code"
        fi
    else
        err "npm no está instalado. Instala Node.js primero: https://nodejs.org"
        warn "Después, instala Claude Code: npm install -g @anthropic-ai/claude-code"
    fi
fi

# ---- 6. Alias en el shell rc
SHELL_NAME=$(basename "${SHELL:-/bin/bash}")
case "$SHELL_NAME" in
    zsh)  RC_FILE="$HOME/.zshrc" ;;
    bash) RC_FILE="$HOME/.bashrc" ;;
    *)    RC_FILE="" ;;
esac

ALIAS_LINE="alias ${OPERATOR_SLUG}='cd ${TARGET} && claude'"
ALIAS_MARKER="# personal-os-bootstrap:${OPERATOR_SLUG}"

if [ -n "$RC_FILE" ]; then
    touch "$RC_FILE"
    if grep -Fq "$ALIAS_MARKER" "$RC_FILE"; then
        warn "Alias ya estaba en $RC_FILE — no lo duplico."
    else
        {
            printf '\n%s\n' "$ALIAS_MARKER"
            printf '%s\n' "$ALIAS_LINE"
        } >> "$RC_FILE"
        ok "Alias añadido a $RC_FILE"
    fi
else
    warn "Shell '$SHELL_NAME' no reconocido. Añade manualmente esta línea a tu shell rc:"
    say "  $ALIAS_LINE"
fi

# ---- 7. Cierre
say ""
hl "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ok "Listo, ${OPERATOR_NAME}."
hl "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
say ""
say "Próximos pasos:"
say ""
say "  ${BOLD}1.${RESET} Abre una terminal ${BOLD}nueva${RESET} (para que cargue el alias)"
say "  ${BOLD}2.${RESET} Escribe:  ${BOLD}${OPERATOR_SLUG}${RESET}"
say "  ${BOLD}3.${RESET} Claude Code arrancará en modo ${BOLD}bootstrap${RESET}."
say "     Te entrevistará para escribir contigo los pilares"
say "     identitarios del sistema. No tardas más de 30-45 min"
say "     si lo haces con atención."
say ""
say "${DIM}Cuando termines, los pilares quedan grabados en rules/ y${RESET}"
say "${DIM}context/, y el OS pasa a modo maduro automáticamente.${RESET}"
say ""
