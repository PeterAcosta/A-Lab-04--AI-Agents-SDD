# Tareas – 001 nginx

> Subordinado a `specs/constitution.md`, `spec.md` y `plan.md`.
> Ejecutar en orden. Marcar `[x]` solo tras pasar la verificación **y** el gate constitucional.

## Gate constitucional (al cerrar CADA tarea)
Antes de marcar una tarea, confirma:
- [ ] La imagen base sigue siendo exactamente `nginx:1.31.7-alpine3.24` (P2).
- [ ] No hardcodeé configuración que debería estar en `.env` (P3).
- [ ] No añadí archivos, servicios ni paquetes fuera del plan (P5).
- [ ] Los scripts son POSIX/`sh` con `set -eu` (P6).
- [ ] La spec y el plan siguen describiendo lo que hice; si no, apliqué el protocolo de cambio (P9).

## Tareas

- [x] **T0. Contexto**
  Leer `constitution.md`, `spec.md` y `plan.md`. Resumir en 5 líneas los invariantes del proyecto, incluyendo la imagen exacta.
  Verificación: el resumen menciona `nginx:1.31.7-alpine3.24`, la jerarquía de autoridad y el protocolo de cambio.

- [x] **T1. Descargar imagen base**
  Ejecutar `docker pull nginx:1.31.7-alpine3.24`.
  Verificación: el comando termina con éxito. Si falla, reportar el error tal cual (red, registro, autenticación). **No cambiar el tag** (P2).

- [x] **T2. Archivos de entorno** (RF5)
  Crear `.env`, `.env.example` y `.gitignore` (con `.env`).
  Verificación: `.env` contiene `APP_MESSAGE` y `NGINX_HOST_PORT=8080`; `.gitignore` contiene `.env`.

- [x] **T3. Entrypoint** (RF4)
  Crear `docker/entrypoint.01-nginx.sh` según RF4 y D3, D4.
  Verificación: `sh -n docker/entrypoint.01-nginx.sh` sin errores; la primera línea es `#!/bin/sh`; contiene `set -eu` y `exec /docker-entrypoint.sh "$@"`.

- [x] **T4. Dockerfile** (RF1, RF2, RF3)
  Crear `docker/Dockerfile.01-nginx` según D1 y D3.
  Verificación:
  `grep -c '^FROM ' docker/Dockerfile.01-nginx` devuelve `1`, y
  `grep -x 'FROM nginx:1.31.7-alpine3.24' docker/Dockerfile.01-nginx` encuentra la línea.
  Además `docker build -f docker/Dockerfile.01-nginx -t nginx-sdd:test .` termina con éxito.

- [x] **T5. docker-compose** (RF2, RF5, RF6, RF7)
  Crear `docker-compose.yaml` según D2, D5, D6.
  Verificación: `docker compose config` sin errores y con los valores de `.env` resueltos.

- [x] **T6. Levantar el entorno** (CA1, CA2)
  Ejecutar `docker compose up -d --build`.
  Verificación: CA1 y CA2 (esperar hasta 30 s a `healthy`).

- [x] **T7. Validar el servidor** (CA3–CA7)
  Ejecutar los comandos de CA3, CA4, CA5, CA6 y CA7.
  Verificación: los cinco criterios pasan.

- [x] **T8. Limpieza** (CA8)
  Ejecutar `docker compose down`.
  Verificación: CA8; `docker compose ps` no lista contenedores.

- [x] **T9. Sincronización spec-anchored**
  Revisar punto por punto la tabla de trazabilidad del plan contra el código real.
  - Si todo coincide: cambiar el estado de `spec.md` a `Implementada`.
  - Si hay diferencias: aplicar el protocolo de cambio (A/B/C) y dejar spec, plan, tareas y código coherentes; si hay una diferencia sin reconciliar, dejar el estado en `Divergente`.
  Verificación: no hay diferencias entre lo documentado y lo construido; el "Registro de cambios" refleja todo lo modificado.

## Hallazgos durante la implementación
_Registro de lo que se descubre al implementar (flujo código → spec). Una fila por hallazgo._

| ID | Tarea | Descripción | Clase (A/B/C) | Acción tomada | ¿Aprobado? |
|---|---|---|---|---|---|
| H1 | T0 | `AGENTS.md` y `CLAUDE.md` citan `tasks.md`, pero el archivo real se llamaba `task.md` | A | Renombrado `task.md` → `tasks.md`; sin impacto en RF/CA ni en la trazabilidad T0–T9 | Sí (usuario) |
| H2 | T4, T6 | El build de Docker necesita escribir en `~/.docker/buildx`, fuera del workspace; sin permiso ampliado falla con `read-only file system` | — (entorno) | Ninguna en spec/plan/código: es un problema de entorno, no de diseño. T4/T6 se ejecutaron con permiso ampliado aprobado por el usuario; el tag no se tocó (P2) | Sí (usuario) |