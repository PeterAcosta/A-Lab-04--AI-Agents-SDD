# Plan de implementación: Servidor Nginx

## 1. Enfoque técnico

El servidor web se implementará utilizando Nginx dentro de un contenedor Docker, con configuración y contenido web externos al contenedor cuando corresponda.

## 2. Arquitectura

- **Servidor web:** Nginx.
- **Contenedorización:** Docker.
- **Imagen base:** `nginx:1.31.7-alpine3.24`.

**Dockerfile:** `./docker/Dockerfile.01-nginx`
**Entrypoint:** `./docker/entrypoint.01-nginx.sh`
**Orquestador:** `./docker-compose.yaml`
**Imagen resultante:** `01-nginx-image:01`
**Contenedor resultante:** `01-nginx`

**Puerto de Nginx:** se lee `NGINX_HOST_PORT` de `./.env` y se inyecta en el contenedor. Compose lo pasa como `build.args.NGINX_PORT` y como `environment.nginx_port`; el Dockerfile lo recibe con `ARG NGINX_PORT` y lo expone como `ENV nginx_port`. El entrypoint renderiza la configuración con ese valor y Nginx escucha en `nginx_port`. Compose publica `${NGINX_HOST_PORT}:${NGINX_HOST_PORT}`.

**Variables de entorno dentro del contenedor:**
- `image_name=nginx:1.31.7-alpine3.24` (imagen base utilizada).
- `nginx_port`, obtenida de `NGINX_HOST_PORT` de `./.env`.

**Dominio de Nginx:** `test.local`.

**Volúmenes Docker:** dos:

```yaml
volumes:
  - ./docker/test.local/:/usr/share/nginx/html
  - ./docker/etc--nginx--conf.d/:/etc/nginx/conf.d/
```

**Configuración de Nginx:** la plantilla `./docker/etc--nginx--conf.d/test.local.conf.template` define `server_name test.local`, `listen ${nginx_port}`, `root /usr/share/nginx/html`, `index index.html`, `error_page 404 /404.html` y `location = /404.html` interno. El entrypoint genera `test.local.conf` en el volumen montado con `envsubst`; Nginx solo carga `*.conf` e ignora la plantilla.

**Entrypoint:** el Dockerfile copia `./docker/entrypoint.01-nginx.sh`, lo marca ejecutable y lo declara como `ENTRYPOINT`; el `CMD` es `["nginx", "-g", "daemon off;"]`. El script valida `nginx_port`, renderiza la configuración y delega en `/docker-entrypoint.sh`.

**Páginas HTML5:** dos páginas estáticas y simples en la raíz del sitio `test.local`: `index.html` y `404.html`.

**Limpieza:** después de terminar, borrar las imágenes, contenedores, redes y volúmenes auxiliares; no tocar nada no creado. La imagen y el contenedor finales de la feature se conservan.

## 3. Operación

- Iniciar: `docker compose up -d --build`.
- Detener: `docker compose stop`.
- Reiniciar: `docker compose start` o `docker compose restart`.
- Para conservar el contenedor final, detener con `docker compose stop`; `docker compose down` elimina el contenedor y la red, pero no los volúmenes bind.

## 4. Consideraciones técnicas

La implementación deberá respetar los requisitos de `spec.md` y los principios establecidos en `constitution.md`.
