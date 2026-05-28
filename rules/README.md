# rules/ — la capa identitaria del OS

Las reglas viven aquí. Cuando algo es ambiguo, gana lo que pone aquí.

**Estado inicial (bootstrap):**

- `_post-bootstrap-CLAUDE.md` — plantilla del CLAUDE.md maduro que se
  promueve a `~/{{OPERATOR_SLUG}}-os/CLAUDE.md` cuando termine el
  bootstrap. **No editar manualmente** durante la sesión cero.
- `README.md` — este archivo.

**Tras el bootstrap (lo que escribirás en sesión 1):**

- `alma.md` — el suelo identitario. Gana sobre todo lo demás.
  Define telos, división del trabajo, voz.
- `constitution.md` — valores duros, restricciones, lo que jamás
  permito.
- `filesystem.md` — el mapa de la casa.

**Capas que pueden aparecer después (sólo cuando hagan falta):**

- `operating-protocol.md` — loop de sesión, qué leo al arrancar.
- `agent-execution.md` — cómo ejecuto comandos y tareas largas.
- `secrets.md` — gestión de API keys / tokens.
- `skill-routing.md` — cuándo invocar qué skill.

No las añadas por anticipación. Añádelas cuando una sesión real
revele que las necesitas.
