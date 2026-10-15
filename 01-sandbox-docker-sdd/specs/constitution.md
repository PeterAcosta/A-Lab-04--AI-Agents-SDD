# Constitución del proyecto

**Versión:** 1.0 · **Estado:** vigente

## Autoridad
Este documento es la máxima autoridad del proyecto. Toda spec, plan, tarea y línea de código debe respetarlo.
Está por encima de `spec.md`, `plan.md`, `tasks.md` y el código. Si algo los contradice, lo que está mal es eso, no la constitución.

## Cómo se usa
- El agente la lee **antes de cualquier trabajo** y antes de proponer cualquier cambio.
- Cada tarea termina con un gate constitucional (ver `tasks.md`).
- Si un cambio la contradice, no se hace. Se expone el conflicto al usuario.

## Principios

**P1. Reproducibilidad.** Todo se levanta con `docker compose up -d --build` desde la raíz del proyecto, sin pasos manuales ocultos.

**P2. Imagen base fija e inmutable.** La imagen base es exactamente `nginx:1.31.7-alpine3.24`.
- Nunca `latest`, nunca otra versión, nunca otra variante (debian, slim, etc.).
- No se parametriza (ni ARG, ni `.env`): es una constante de diseño, no configuración.
- Aparece en un único lugar: el `FROM` de `docker/Dockerfile.01-nginx`.
- Si la descarga o el build fallan, se reporta el error. Jamás se cambia la imagen para "hacerlo funcionar".

**P3. Configuración por entorno.** Los valores que varían entre entornos (mensaje, puerto del host) viven en `.env`. No se hardcodean en Dockerfile, compose ni scripts. Las constantes de diseño (como P2) no son configuración.

**P4. Sin secretos en git.** `.env` está en `.gitignore`. Se versiona `.env.example`.

**P5. Mínimo necesario.** Solo nginx. Sin servicios extra, sin paquetes adicionales, sin archivos fuera de los previstos en el plan.

**P6. Scripts POSIX.** La imagen es Alpine: `#!/bin/sh` (no bash), con `set -eu`, y saltos de línea LF.

**P7. El entrypoint no rompe la imagen.** El entrypoint propio debe terminar con `exec /docker-entrypoint.sh "$@"` para conservar el comportamiento oficial de nginx y el manejo correcto de señales.

**P8. Todo es verificable.** Cada requisito tiene al menos un criterio de aceptación comprobable por comando.

**P9. Spec-anchored: spec y código no divergen en silencio.** Todo cambio pasa por el protocolo de cambio de `AGENTS.md` y queda registrado. Nada de deriva silenciosa.

**P10. Idioma.** Documentación y comentarios en español.

## Gobernanza
- Solo el usuario puede enmendar esta constitución. El agente puede proponer enmiendas, nunca aplicarlas.
- Cada enmienda sube la versión y se anota abajo.

## Historial de enmiendas
| Versión | Fecha | Cambio |
|---|---|---|
| 1.0 | (fecha de creación) | Versión inicial |