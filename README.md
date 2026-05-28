# Personal OS Bootstrap

Un sistema operativo personal que aprende cómo trabajas. No es un
chatbot: es una capa de inteligencia con memoria que se queda contigo
sesión a sesión.

Lo que estás a punto de instalar **no incluye tu identidad** — eso lo
escribirás tú en la primera sesión, en diálogo con el sistema. Lo que
incluye es la **maquinaria**: la forma en que el sistema arranca, lee
contexto, y guarda lo que aprende.

---

## Pre-requisitos

- Una **cuenta Anthropic** (gratis o de pago) — la suscripción de
  Claude funciona.
- **Node.js** instalado (https://nodejs.org si no lo tienes).
- macOS o Linux. Una terminal cualquiera (Terminal.app, iTerm,
  cualquiera).

---

## Instalación

```bash
git clone https://github.com/ignaciosatrustegui/personal-os-bootstrap.git
cd personal-os-bootstrap
bash install.sh
```

El instalador te preguntará tu nombre y un slug corto (p.ej. `alvaro`),
y creará `~/[slug]-os/` con el esqueleto del sistema. También añadirá
un alias a tu shell para que escribiendo tu slug en una terminal nueva
se abra el OS.

---

## Primera sesión — qué esperar

Abres una terminal nueva, escribes tu slug, y se abre Claude Code en
modo **bootstrap**. El sistema te entrevistará en cuatro fases:

1. **Telos** — ¿para qué quieres este sistema?
2. **Identidad y restricciones** — quién eres, cómo trabajas, qué
   jamás permites.
3. **División del trabajo** — qué hace el sistema, qué te reservas tú.
4. **La casa** — cómo organizas las cosas.

Al final de la sesión (30-45 min si vas con calma) habrás escrito
**con el sistema**, no por encargo:

- `rules/alma.md` — el suelo identitario
- `rules/constitution.md` — valores duros
- `rules/filesystem.md` — el mapa de tu casa
- `context/entity.md` — quién eres
- `context/now.md` — estado vivo
- `context/next-steps.md` — prioridades

Desde la siguiente sesión, el sistema arranca leyendo esos archivos
y opera desde tu identidad.

---

## Filosofía

- El sistema **no asume** quién eres. Te pregunta.
- Las respuestas vagas no se aceptan — te pide ejemplos concretos.
- Tú apruebas cada archivo antes de que se escriba.
- El operador (tú) tiene siempre el voto de casting.

---

## Estructura

```
~/[slug]-os/
├── CLAUDE.md         # kernel-load del sistema
├── rules/            # alma, constitution, filesystem (los escribes en sesión 1)
├── context/          # entity, now, next-steps (los escribes en sesión 1)
├── minds/            # mentes invocables (vacío al inicio)
├── skills/           # skills personalizados (vacío al inicio)
├── memory/           # auto-memory persistente
└── .claude/          # config de Claude Code (permisos mínimos)
```

---

## Después de la primera sesión

El sistema crece según uso. Cuando necesites algo (una skill, una
mente, una regla nueva), pídelo en sesión y el sistema lo añade
contigo. No hay versión "completa". Se hace más útil cuanto más lo
usas.

---

## Créditos

Este template está extraído del **Ignacio OS**, el sistema personal
de [Ignacio Satrustegui](https://github.com/ignaciosatrustegui). El
bootstrap está diseñado para que tu OS sea **tuyo**, no una copia del
suyo.
