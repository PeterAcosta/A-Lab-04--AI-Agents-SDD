# Plan: Servidor web Nginx en Docker

Referencias: `spec.md`, `specs/constitution.md`, `AGENTS.md`, `.env`.

## Enfoque

Imagen propia desde `nginx:1.28.0-bookworm@sha256:552e7481ca93ffccd046aa658dbbed22caefbc09c66fa7cd247cbb90b8a5c609`; `apt` instala `logrotate` y `cron`. Compose publica el puerto, monta los volúmenes, inyecta `APP_MESSAGE` y limita los logs. El entrypoint genera `message.html`, arranca `cron` y delega en `/docker-entrypoint.sh`.

## Estructura

```
03-sandbox/
├── docker-compose.yaml
├── .env
├── README.md
├── docker/
│   ├── Dockerfile.01-nginx
│   ├── entrypoint.01-nginx.sh
│   ├── logrotate.01-nginx.conf
│   └── cron.01-nginx
├── vol-01-nginx-conf.d/test.local.conf
├── vol-01-nginx-logs/          # generado
└── vol-01-nginx-web/
    ├── index.html
    ├── 404.html
    ├── 500.html
    └── message.html            # generado
```

## Decisiones

| DT | Decisión |
|---|---|
| DT-01 | Imagen `nginx:1.28.0-bookworm@sha256:552e7481ca93ffccd046aa658dbbed22caefbc09c66fa7cd247cbb90b8a5c609`; `logrotate 3.21.0-1` y `cron 3.0pl1-162` por `apt`. |
| DT-02 | Nginx escucha en `80`; Compose publica `${NGINX_HOST_PORT}:80`; URL `http://test.local:<puerto>/`; `up -d` recrea. |
| DT-03 | `test.local.conf`: `server_name test.local`, root `/var/www/x-site`, `index`, `ssi on`, `error_page 404/500`, `location` internos y `/__verificacion/500`; el `default.conf` queda oculto y la config es autosuficiente. |
| DT-04 | `conf.d` en `ro`; logs y web en `rw`; `vol-01-nginx-logs` en `755`; archivos web/config en `644`. |
| DT-05 | Entrypoint: valida `APP_MESSAGE`, genera `message.html`, arranca cron, emite `entrypoint: listo` y ejecuta el entrypoint oficial. |
| DT-06 | `index.html` incluye `message.html` por SSI; se regenera al arrancar; `APP_MESSAGE` es texto plano sin `&`, `<` ni `>` y se escapa como defensa. |
| DT-07 | `logrotate`: `maxsize 10M`, `rotate 3`, `compress`, `delaycompress`, `USR1`; cron horario (`17 * * * *`) con salida a `logrotate-cron.log`, cubierto por `*.log`. |
| DT-08 | Servicio `nginx`, contenedor `03-nginx`, imagen `03-nginx-image:01`, build `docker/Dockerfile.01-nginx`. |
| DT-09 | README: requisitos, arranque, verificación, puerto/APP_MESSAGE, logs y límites, archivos root, versiones, stop/down. |
| DT-10 | Docker `json-file` `max-size 10m` y `max-file 3`; logs del host fuera de alcance; `down` no borra los logs de Nginx del volumen. |

## Verificación

| CA | Prueba |
|---|---|
| CA-01/02/03 | `docker compose ps` Up, puerto `8080->80`, `curl` 200 con título, mensaje y `APP_MESSAGE`. |
| CA-04/05 | Editar `index.html` y `curl`; `stop`/`start` y `curl` 200. |
| CA-06/07 | `curl` a ruta inexistente y a `/__verificacion/500`. |
| CA-08/11 | `logrotate -f`, archivos rotados, `logrotate-cron.log`, patrón `*.log` y cron activo. |
| CA-09 | Puerto `8081`, `up -d`, `curl`; restaurar `8080`. |
| CA-10 | `docker inspect` con `json-file`/límites; `docker compose logs` con `entrypoint: listo`. |

## Riesgos

- Puerto ocupado: cambiar `NGINX_HOST_PORT`.
- `APP_MESSAGE` con `&<>`: restringido y escapado como defensa.
- `logrotate` puede rechazar directorios escribibles por grupo: usar `755`.
- `default.conf` oculto: config autosuficiente y `nginx -t`.
- `cron` sin syslog: la salida de la tarea se redirige a archivo.
- Logs del daemon Docker y del host: fuera de alcance.
- Imagen fijada por digest; el pull se verificó al construir.

## Cierre

Implementado cuando todas las tareas estén verificadas y CA-01..CA-11 comprobados; evidencia en `z-report.md`.
