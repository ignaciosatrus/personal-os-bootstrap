# scripts/

Scripts ejecutables del OS. Lo más importante de aquí es lo que se
invoca como **hook** por Claude Code, no como comando del operador.

## `init-session.sh` — kernel-load

Hook SessionStart. Se ejecuta automáticamente cada vez que abres una
sesión de Claude Code en este OS. Inyecta como contexto:

- `rules/alma.md` (suelo identitario)
- `rules/filesystem.md` (mapa de la casa)
- `context/now.md` (estado vivo)
- `context/next-steps.md` (prioridades)

Si los pilares todavía no existen (sesión cero / bootstrap), anuncia
modo bootstrap y sale sin cargar nada.

**Configurado en:** `.claude/settings.json` (clave `hooks.SessionStart`).

**Invocable manualmente para inspección:**

```
bash scripts/init-session.sh
```

## Añadir más scripts

A medida que el OS madure, aquí pueden vivir:

- `stop-session.sh` — captura de learnings o resumen al cerrar sesión.
- `pre-tool-guard.py` — guardrails antes de ejecutar comandos.
- Health checks específicos del operador.

No los añadas por anticipación. Aparecen cuando una sesión real revela
que los necesitas, y se documentan aquí entonces.
