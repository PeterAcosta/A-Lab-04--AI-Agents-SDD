# 001 – Servidor nginx en Docker

**Versión:** 0.1 · **Estado:** Implementada
_Estados posibles: Borrador → Aprobada → Implementada → Divergente (si el código se desvió y hay que reconciliar)._

> Este documento está sujeto a `specs/constitution.md` (autoridad superior).
> Es spec-anchored: se mantiene sincronizada con el código. Cambios según el protocolo de `AGENTS.md`.

## Objetivo
Tener un contenedor nginx funcional, construido desde un Dockerfile propio sobre la imagen `nginx:1.31.7-alpine3.24`, con un entrypoint propio y configuración tomada de `.env`.

## Alcance
Incluye: Dockerfile, entrypoint, docker-compose, `.env`, verificación en el puerto 8080.
No incluye: HTTPS, proxy reverso a otros servicios, volúmenes persistentes, CI.

## Requisitos funcionales
- **RF1.** La imagen base es exactamente `nginx:1.31.7-alpine3.24` (constitución P2). Es un invariante.
- **RF2.** El contenedor se construye con `docker/Dockerfile.01-nginx`.
- **RF3.** El contenedor usa `docker/entrypoint.01-nginx.sh` como ENTRYPOINT.
- **RF4.** El entrypoint:
  1. Escribe en el log una línea con prefijo `[entrypoint.01-nginx]`.
  2. Falla con mensaje claro si `APP_MESSAGE` no está definida.
  3. Genera `/usr/share/nginx/html/index.html` incluyendo el valor de `APP_MESSAGE`.
  4. Termina con `exec /docker-entrypoint.sh "$@"` (constitución P7).
- **RF5.** `APP_MESSAGE` y `NGINX_HOST_PORT` se definen en `.env`. `APP_MESSAGE` se inyecta al contenedor desde `docker-compose.yaml`. `NGINX_HOST_PORT` solo se usa en compose para publicar el puerto.
- **RF6.** nginx escucha en el puerto 80 dentro del contenedor y se publica en el host como `${NGINX_HOST_PORT}` (valor 8080). _(Ver D2 en el plan.)_
- **RF7.** El contenedor define un `healthcheck` que consulta nginx localmente.

## Variables de entorno
| Variable | Valor en `.env` | Uso | Restricción |
|---|---|---|---|
| `APP_MESSAGE` | `Hola desde nginx con SDD` | Texto mostrado en el `index.html` | Texto plano, sin `&`, `<`, `>` |
| `NGINX_HOST_PORT` | `8080` | Puerto publicado en el host | Entero entre 1024 y 65535 |

## Criterios de aceptación
- **CA1.** `docker compose up -d --build` termina sin errores.
- **CA2.** `docker compose ps` muestra el servicio `nginx` en `running` y, tras unos segundos, `healthy`.
- **CA3.** `curl -s -o /dev/null -w "%{http_code}" http://localhost:8080` devuelve `200`.
- **CA4.** `curl -s http://localhost:8080` contiene el texto de `APP_MESSAGE`.
- **CA5.** `docker compose exec nginx printenv APP_MESSAGE` devuelve el valor definido en `.env`.
- **CA6.** `docker compose logs nginx` muestra la línea `[entrypoint.01-nginx]` antes de los logs de nginx.
- **CA7.** Imagen fijada: `docker/Dockerfile.01-nginx` contiene una única línea `FROM` y es exactamente `FROM nginx:1.31.7-alpine3.24`; además `docker compose exec nginx nginx -v` reporta la versión `1.31.7`.
- **CA8.** `docker compose down` detiene y elimina el contenedor sin errores.

## Puntos abiertos
- Ninguno bloqueante. El tag `nginx:1.31.7-alpine3.24` está confirmado por el usuario.
- Revisable: D2 (puerto publicado 8080→80 vs. nginx escuchando directamente en 8080 dentro del contenedor).

## Registro de cambios
| Versión | Fecha | Tipo | Cambio | Motivo | Aprobado por |
|---|---|---|---|---|---|
| 0.1 | (fecha) | — | Versión inicial | — | usuario |
| 0.1 | 2026-10-15 | Estado | Estado: Aprobada → Implementada tras verificar CA1–CA8 (T6–T8) | Cierre de T9 (sincronización spec-anchored); sin cambios en RF ni CA | usuario |