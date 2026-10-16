# Plan técnico – 001 nginx

> Deriva de `spec.md` y está subordinado a `specs/constitution.md`.
> Spec-anchored: si la implementación obliga a cambiar el plan, se actualiza aquí y se registra según `AGENTS.md`.

## Decisiones
- **D1. Imagen fija.** `FROM nginx:1.31.7-alpine3.24` en el Dockerfile. Sin ARG, sin variable, sin `latest` (P2, RF1).
- **D2. Puertos.** nginx escucha en 80 dentro del contenedor. Compose publica `"${NGINX_HOST_PORT}:80"`, con `NGINX_HOST_PORT=8080` (RF6).
  _Decisión revisable_: si se quisiera que nginx escuche en 8080 dentro del contenedor, requiere cambio tipo B en la spec (RF6) y un template de configuración.
- **D3. Entrypoint envoltorio.** Nuestro script hace su trabajo y delega con `exec /docker-entrypoint.sh "$@"`. El `CMD` queda `["nginx", "-g", "daemon off;"]` (P7, RF3, RF4).
- **D4. Variable inyectada.** `APP_MESSAGE` se usa para generar el `index.html`, lo que prueba que la variable llegó y que el entrypoint se ejecutó (RF4, RF5).
- **D5. Healthcheck.** `wget -q -O /dev/null http://127.0.0.1/` (wget viene en Alpine/busybox; no se instala nada, P5).
- **D6. Compose explícito.** Un solo servicio `nginx` con `build.context: .`, `build.dockerfile: docker/Dockerfile.01-nginx`, `image: nginx-sdd:01`, `environment` con `APP_MESSAGE=${APP_MESSAGE:?definir APP_MESSAGE en .env}`, `ports` según D2 y `restart: unless-stopped`.

- **D7. Limpieza de imágenes.** Tras `docker compose down`, ejecutar `docker rmi nginx-sdd:01 nginx-sdd:test`. Se usan nombres explícitos y no `--rmi local`, porque ese flag no borra imágenes que tienen un tag personalizado (`image:` en compose). Nunca se elimina la imagen base (RF8, P2).


## Archivos permitidos
| Archivo | Contenido |
|---|---|
| `.env` | `APP_MESSAGE`, `NGINX_HOST_PORT` |
| `.env.example` | Copia de `.env` sin datos sensibles |
| `.gitignore` | Ignora `.env` |
| `docker/Dockerfile.01-nginx` | FROM (D1), COPY del entrypoint, `chmod +x`, ENTRYPOINT, CMD |
| `docker/entrypoint.01-nginx.sh` | `set -eu`, log, validar `APP_MESSAGE`, generar index.html, `exec` |
| `docker-compose.yaml` | Servicio `nginx` según D2, D5, D6 |

Ningún otro archivo, salvo aprobación (P5).

## Trazabilidad
| Requisito | Se implementa en | Tarea | Se verifica con |
|---|---|---|---|
| RF1 | `docker/Dockerfile.01-nginx` | T4 | CA7 |
| RF2 | `docker/Dockerfile.01-nginx`, compose | T4, T5 | CA1 |
| RF3 | Dockerfile | T4 | CA6 |
| RF4 | `docker/entrypoint.01-nginx.sh` | T3 | CA4, CA6 |
| RF5 | `.env`, compose | T2, T5 | CA5 |
| RF6 | compose | T5 | CA3 |
| RF7 | compose | T5 | CA2 |
| RF8 | comandos de limpieza | T8 | CA9 |


## Consideraciones técnicas
- El script debe guardarse con saltos de línea LF, no CRLF (P6).
- Los permisos de ejecución se aseguran con `chmod +x` dentro del Dockerfile.
- `APP_MESSAGE` se trata como texto plano (ver restricción en la spec).

## Historial de cambios del plan
| Fecha | Cambio | Origen (hallazgo/RF) |
|---|---|---|
| (fecha) | Versión inicial | — |
| (fecha) | Añadida D7: limpieza de imágenes | RF8 |
