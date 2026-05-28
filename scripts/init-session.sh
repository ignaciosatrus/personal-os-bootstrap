#!/bin/bash
# init-session.sh — kernel-load del {{OPERATOR_NAME}} OS
#
# Invocado automáticamente por hook SessionStart de Claude Code,
# configurado en .claude/settings.json del proyecto.
#
# Stdout se inyecta como contexto al agente al arrancar sesión,
# garantizando que cada conversación arranca con alma + filesystem +
# estado vivo cargados — sin depender de que el agente recuerde
# leerlos.
#
# Invocable manualmente para inspección:
#   $ bash scripts/init-session.sh

REPO="${CLAUDE_PROJECT_DIR:-$(pwd)}"

# === ¿Modo bootstrap? (pilares aún no escritos)

if [ ! -f "$REPO/rules/alma.md" ]; then
    cat <<'EOF'
===== MODO BOOTSTRAP =====

Los pilares identitarios (alma, constitution, filesystem, entity,
now, next-steps) todavía no existen. Esta sesión es la entrevista
para escribirlos.

El CLAUDE.md raíz contiene el protocolo de entrevista. Léelo antes
de hacer cualquier otra cosa, y sigue las cuatro fases sin saltar
ninguna.

(El kernel-load real se activará automáticamente desde la siguiente
sesión, cuando alma.md ya exista.)
EOF
    exit 0
fi

# === Modo maduro: kernel-load de los 4 pilares canonical

echo "===== rules/alma.md (suelo identitario — gana sobre todo) ====="
cat "$REPO/rules/alma.md"
echo ""

echo "===== rules/filesystem.md (mapa de la casa) ====="
cat "$REPO/rules/filesystem.md" 2>/dev/null || echo "(no existe — todavía sin mapa explícito)"
echo ""

echo "===== context/now.md (estado vivo) ====="
cat "$REPO/context/now.md" 2>/dev/null || echo "(no existe — sesión sin estado registrado)"
echo ""

echo "===== context/next-steps.md (prioridades) ====="
cat "$REPO/context/next-steps.md" 2>/dev/null || echo "(no existe — sin pendientes registrados)"
echo ""

echo "===== Kernel-load completo. Operar desde aquí, respetando alma. ====="
