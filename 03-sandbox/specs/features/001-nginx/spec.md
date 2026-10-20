# Spec: Servidor web Nginx en Docker

## 1. Objetivo

Contenedor Nginx que sirve HTML estático por HTTP, con configuración reproducible y logs acotados.

## 2. Alcance

Incluye: Nginx en Docker, `test.local`, `index.html`, `404.html`, `500.html`, puerto de `.env`, rotación de logs y límites de logs del contenedor.

Fuera de alcance: HTTPS/TLS, dominios propios, aplicaciones dinámicas o bases de datos, balanceo o réplicas, y logs del daemon de Docker y del host.

## 3. Estructura

- `docker-compose.yaml`; `docker/Dockerfile.01-nginx`; `docker/entrypoint.01-nginx.sh`; `docker/logrotate.01-nginx.conf`; `docker/cron.01-nginx`.
- `.env`: `NGINX_HOST_PORT` y `APP_MESSAGE`.
- Volúmenes: `./vol-01-nginx-conf.d/` -> `/etc/nginx/conf.d/`; `./vol-01-nginx-logs/` -> `/var/log/nginx/`; `./vol-01-nginx-web/` -> `/var/www/x-site/`.
- `test.local.conf` sirve `test.local` con root `/var/www/x-site/`; `index.html`, `404.html` (`Página no encontrada`) y `500.html` (`Error interno del servidor`).
- `README.md` con operación. `logrotate.01-nginx.conf` y `cron.01-nginx` se justifican por RF-07.

## 4. Requisitos funcionales

| ID | Requisito |
|---|---|
| RF-01 | Contenedor Nginx operativo. |
| RF-02 | Nginx escucha en `80`; el host publica `NGINX_HOST_PORT`; `docker compose up -d` refleja cambios; URL `http://test.local:<puerto>/`. |
| RF-03 | `test.local` sirve `/var/www/x-site/`; `GET /` entrega `index.html`. |
| RF-04 | Página con título `Servidor Nginx en Docker`, mensaje fijo `El servidor está funcionando correctamente.` y `APP_MESSAGE` (texto plano, leído al iniciar, sin `&`, `<` ni `>`). |
| RF-05 | `404.html` y `500.html` personalizadas. |
| RF-06 | `stop`/`start` sin reconstruir la imagen. |
| RF-07 | `logrotate` rota `/var/log/nginx/`; la salida de la tarea va a un archivo rotado. |
| RF-08 | stdout/stderr acotados por el driver de Docker. |

## 5. RNF y restricciones

- RNF-01: reproducible; imagen por etiqueta y digest; versiones resueltas documentadas.
- RNF-02: configuración sencilla y mantenible.
- RNF-03: contenido persistente en el host.
- RNF-04: Linux con Docker Engine y Compose.
- Restricciones: imagen oficial, HTTP sin TLS, sin dependencias innecesarias y respeto a la constitución.

## 6. Criterios de aceptación

| ID | Criterio |
|---|---|
| CA-01 | Contenedor en ejecución. |
| CA-02 | `http://test.local:8080/` (o puerto vigente) responde `200`. |
| CA-03 | Contiene título, mensaje fijo y `APP_MESSAGE`. |
| CA-04 | Editar `index.html` se refleja sin tocar el contenedor. |
| CA-05 | Tras `stop`/`start` sirve de nuevo. |
| CA-06 | Ruta inexistente -> `404` con `Página no encontrada`. |
| CA-07 | `/__verificacion/500` -> `500` con `Error interno del servidor`. |
| CA-08 | `logrotate -f` deja un archivo rotado y el servicio sigue. |
| CA-09 | Cambiar `NGINX_HOST_PORT` y `up -d` publica el nuevo puerto. |
| CA-10 | `docker inspect` muestra `json-file` con `max-size`/`max-file`; `docker compose logs` muestra `entrypoint: listo`. |
| CA-11 | `logrotate-cron.log` existe y está cubierto por `*.log`. |

## 7. Verificación

Comprobar estado, puerto, HTTP, contenido, 404/500, edición, reinicio, rotación, cambio de puerto y límites de logs; registrar comandos y salidas.

## 8. Decisiones de implementación

Los detalles no fijados se definen en `plan.md`; cambiar requisitos exige actualizar esta spec.
