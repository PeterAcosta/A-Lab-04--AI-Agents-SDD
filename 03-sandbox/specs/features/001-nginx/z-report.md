# Reporte 001-nginx

## Hecho

- Imagen `03-nginx-image:01` construida desde `nginx:1.28.0-bookworm@sha256:552e7481ca93ffccd046aa658dbbed22caefbc09c66fa7cd247cbb90b8a5c609`.
- Contenedor `03-nginx` sirviendo `test.local:8080` con `index.html`, `404.html`, `500.html` y `message.html` generado.
- Entrypoint con `APP_MESSAGE` por SSI, `cron` y `logrotate` dentro del contenedor.
- Límites de logs: Nginx `maxsize 10M` con `rotate 3`; Docker `json-file` `max-size 10m` y `max-file 3`.
- `README.md` y `tasks.md` actualizados; T-01 a T-15 verificadas y marcadas.

## Verificado

- CA-01/02/03: contenedor `Up`, puerto `8080->80`, HTTP `200` con título, mensaje fijo y `APP_MESSAGE`.
- CA-04/05: cambio en `index.html` reflejado por bind mount; `docker compose stop`/`start` y HTTP `200`.
- CA-06/07: `404` con `Página no encontrada` y `500` con `Error interno del servidor`.
- CA-08/11: `access.log.1` y `error.log.1` rotados; HTTP `200`; `logrotate-cron.log` creado; patrón `*.log`; cron activo.
- CA-09/10: cambio a `8081` y restauración a `8080`; `json-file` con `max-file=3` y `max-size=10m`; `entrypoint: listo` visible.

## No verificado

- Ejecución automática de `cron` a la hora programada; se verificaron configuración, daemon y ejecución manual.
- Rotación automática de los logs de Docker al alcanzar `10m`; solo se verificó la configuración.
- Comportamiento bajo carga alta o más de 10 MB de log entre dos ejecuciones horarias.

## Problemas y errores

- HTTP `403` inicial por HTML en modo `600`; corregido a `644` para que el worker de Nginx los lea.
- Build bloqueado por el sandbox en `~/.docker/buildx`; se usaron `DOCKER_CONFIG` y `BUILDX_CONFIG` locales, retirados al finalizar.
- `logrotate-cron.log` quedó en `0` bytes porque `logrotate` no emitió salida; el archivo existe y está cubierto por `*.log`.

## Divergencias spec/código

- Ninguna.
