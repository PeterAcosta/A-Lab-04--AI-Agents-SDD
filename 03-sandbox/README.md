# Servidor Nginx en Docker

Servidor web estático con Nginx en un contenedor Docker, configuración reproducible y rotación de logs.

## Requisitos

- Docker Engine.
- Docker Compose.
- `test.local` definido en `/etc/hosts` apuntando a `127.0.0.1`.

## Arranque

```bash
docker compose up -d --build
```

La imagen se construye desde `docker/Dockerfile.01-nginx` y se publica como `03-nginx-image:01`.

## Verificación

```bash
docker compose ps
docker compose port nginx 80
curl -i http://test.local:8080/
curl -i http://test.local:8080/no-existe
curl -i http://test.local:8080/__verificacion/500
docker compose logs --tail=100
```

- `http://test.local:8080/` debe responder `200 OK` con el título `Servidor Nginx en Docker`, el mensaje fijo y el valor de `APP_MESSAGE`.
- `/no-existe` debe responder `404` con `Página no encontrada`.
- `/__verificacion/500` es una ruta exclusiva de verificación y debe responder `500` con `Error interno del servidor`.

Si `NGINX_HOST_PORT` cambia en `.env`, sustituir `8080` por el puerto vigente.

## Contenido y persistencia

- El document root es `./vol-01-nginx-web/`, montado en `/var/www/x-site/`.
- Editar `./vol-01-nginx-web/index.html` y volver a solicitar la página; no hace falta reconstruir la imagen.
- `message.html` lo genera el entrypoint a partir de `APP_MESSAGE` en cada arranque. No editarlo a mano.
- `APP_MESSAGE` es texto plano y no debe contener `&`, `<` ni `>`.

## Puerto y mensaje

- Para cambiar el puerto, editar `NGINX_HOST_PORT` en `.env` y ejecutar `docker compose up -d`.
- Para cambiar el mensaje, editar `APP_MESSAGE` en `.env` y reiniciar el servicio con `docker compose restart` o `docker compose up -d`.

## Logs

- Nginx escribe en `./vol-01-nginx-logs/` (`access.log`, `error.log` y `logrotate-cron.log`).
- `logrotate` usa `maxsize 10M` y `rotate 3`; el cron interno lo ejecuta cada hora.
- La salida de la tarea de rotación queda en `./vol-01-nginx-logs/logrotate-cron.log`.
- Los logs de stdout/stderr del contenedor usan el driver `json-file` con `max-size: 10m` y `max-file: 3`.
- Los archivos generados y los logs pueden pertenecer a `root`; consultarlos con `sudo ls -l vol-01-nginx-logs/` si es necesario.
- `docker compose down` elimina el contenedor y sus logs `*-json.log`, pero no los logs de Nginx del volumen.
- Los logs del daemon de Docker y del sistema operativo host quedan fuera del alcance de este proyecto.

Rotación forzada para verificación:

```bash
docker compose exec nginx logrotate -f /etc/logrotate.d/nginx
```

## Parada

```bash
docker compose stop
docker compose down
```

`docker compose stop` conserva el contenedor; `docker compose down` lo elimina.

## Versiones

- Imagen base: `nginx:1.28.0-bookworm@sha256:552e7481ca93ffccd046aa658dbbed22caefbc09c66fa7cd247cbb90b8a5c609`.
- Nginx: `1.28.0`.
- `logrotate`: `3.21.0-1`.
- `cron`: `3.0pl1-162`.
