# Reporte 001-nginx

## Hecho
- Se crearon `docker/Dockerfile.01-nginx`, `docker/entrypoint.01-nginx.sh`, `docker/etc--nginx--conf.d/test.local.conf.template`, `docker/test.local/index.html`, `docker/test.local/404.html` y `docker-compose.yaml`.
- La imagen `01-nginx-image:01` se construyó y el contenedor `01-nginx` quedó en ejecución.
- El entrypoint genera `test.local.conf` desde la plantilla con `envsubst` y delega en `/docker-entrypoint.sh`.
- El dominio `test.local` y el puerto `8080` se aplicaron desde `.env`.
- Las tasks T-01 a T-09 quedaron marcadas como completadas.

## Verificado
- `docker compose build` -> imagen `01-nginx-image:01` construida.
- `curl http://127.0.0.1:8080/` -> HTTP 200 con "Servidor Nginx".
- `curl http://127.0.0.1:8080/recurso-inexistente` -> HTTP 404 con "404 - Recurso no encontrado".
- `curl http://test.local:8080/` -> HTTP 200; `getent hosts test.local` -> `127.0.0.1`; `docker port 01-nginx` -> `8080/tcp`.
- `docker compose down` + `up`, `stop` + `start` y `restart` -> HTTP 200 y contenido persistente.

## No verificado
- Ninguno.

## Problemas y errores
- Buildx no pudo escribir en `~/.docker` por el sandbox -> se usó `DOCKER_CONFIG` dentro del workspace (eliminado al terminar) -> build correcto.
- Los HTML se crearon con permisos 600 -> Nginx devolvía HTTP 403 -> se corrigieron a 644.
- `docker compose down` elimina el contenedor final -> se usó `docker compose stop` para conservarlo -> contenedor en ejecución.

## Divergencias spec/código
- Ninguno.

## Esfuerzo
- Inicio de sesión: 2026-10-17T22:41:14-03:00; reporte: 2026-10-17T23:06:13-03:00 (24 min 59 s); corte de medición: 2026-10-17T23:10:10-03:00 (28 min 56 s).
- Implementación (archivos creados a las 23:04:01) a reporte: 2 min 12 s; el tiempo incluye esperas y correcciones, no es tiempo efectivo.
- Tokens procesados al corte de 23:10:10: 8.422.243 (suma de `totalTokens` por llamada).
- Desglose: entrada 45.104; salida 137.651 (incluye 109.217 de razonamiento); lectura de caché 8.239.488.
- Entrada + salida sin caché: 182.755; el conteo no incluye el mensaje final de este turno.
