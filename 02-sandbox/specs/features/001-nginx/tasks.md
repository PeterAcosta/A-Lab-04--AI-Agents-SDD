# Tareas de implementación: Servidor Nginx

## Referencias

- `spec.md`: requisitos funcionales, operativos y criterios de aceptación.
- `plan.md`: arquitectura y decisiones técnicas.
- `constitution.md`: principios y reglas obligatorias del proyecto.

## Tareas

### T-01: Revisar las especificaciones
- [x] Leer `constitution.md` y verificar sus principios.
- [x] Revisar `spec.md` y `plan.md`.
- [x] Comprobar la estructura existente del proyecto y respetar sus convenciones.

### T-02: Crear el Dockerfile
- [x] Crear `./docker/Dockerfile.01-nginx`.
- [x] Utilizar la imagen base `nginx:1.31.7-alpine3.24`.
- [x] Recibir `NGINX_PORT` como `ARG` y exponerlo como `ENV nginx_port`; definir `ENV image_name=nginx:1.31.7-alpine3.24`.
- [x] Copiar `./docker/entrypoint.01-nginx.sh`, darle permisos de ejecución y declararlo como `ENTRYPOINT`.
- [x] Definir `CMD ["nginx", "-g", "daemon off;"]`.
- [x] Dejar la imagen preparada para ser etiquetada por Compose como `01-nginx-image:01`.

### T-03: Preparar la configuración de Nginx
- [x] Crear `./docker/etc--nginx--conf.d/test.local.conf.template` (crear el directorio si no existe).
- [x] Configurar `server_name test.local;`.
- [x] Definir `root /usr/share/nginx/html;` e `index index.html;`.
- [x] Configurar `error_page 404 /404.html;` y `location = /404.html { internal; }`.
- [x] Usar `listen ${nginx_port};` en la plantilla.
- [x] Verificar que Nginx solo cargue archivos `*.conf` y no la plantilla `.template`.

### T-04: Crear el entrypoint
- [x] Crear `./docker/entrypoint.01-nginx.sh`.
- [x] Validar que `nginx_port` esté definida y no vacía.
- [x] Renderizar `/etc/nginx/conf.d/test.local.conf` desde `test.local.conf.template` con `envsubst`, sustituyendo solo `${nginx_port}`.
- [x] Delegar en `/docker-entrypoint.sh` para conservar el arranque oficial.
- [x] Garantizar que Nginx se ejecute en primer plano dentro del contenedor.
- [x] Verificar que el script sea ejecutable y arranque correctamente.

### T-05: Crear el contenido web
- [x] Crear `./docker/test.local/`.
- [x] Crear `./docker/test.local/index.html` con una página HTML5 estática, simple y válida.
- [x] Crear `./docker/test.local/404.html` con una página HTML5 estática para los recursos inexistentes.

### T-06: Configurar Docker Compose
- [x] Crear o actualizar `./docker-compose.yaml`.
- [x] Definir la construcción con contexto `.` y `dockerfile: docker/Dockerfile.01-nginx`.
- [x] Asignar a la imagen construida el nombre `01-nginx-image` y tag `01`.
- [x] Asignar el nombre de contenedor `01-nginx`.
- [x] Leer del archivo `./.env` el puerto `NGINX_HOST_PORT`.
- [x] Pasar `NGINX_HOST_PORT` como `build.args.NGINX_PORT` y como `environment.nginx_port`.
- [x] Publicar el puerto con `"${NGINX_HOST_PORT}:${NGINX_HOST_PORT}"`.
- [x] Configurar los volúmenes `./docker/test.local/` y `./docker/etc--nginx--conf.d/`.
- [x] Verificar que la configuración y el contenido persistan al recrear el contenedor.

### T-07: Verificar el acceso al dominio
- [x] Comprobar que el servidor responda al dominio `test.local`.
- [x] Verificar que el dominio resuelva desde el host con `getent hosts test.local`.
- [x] Comprobar el acceso al servidor mediante el puerto publicado por Docker.

### T-08: Validar los criterios de aceptación

- [x] **CA-01:** comprobar que una solicitud a `/` devuelve HTTP `200 OK` y muestra la página principal esperada.
- [x] **CA-02:** comprobar que una solicitud a un recurso inexistente devuelve HTTP `404 Not Found`.
- [x] **CA-03:** comprobar que el servidor responde correctamente desde el puerto publicado por Docker.
- [x] **CA-04:** comprobar que la configuración y el contenido persisten después de recrear el contenedor utilizando los volúmenes definidos.
- [x] **CA-05:** comprobar que una solicitud a `http://test.local:<puerto publicado>/` devuelve HTTP `200 OK` y la página principal esperada.
- [x] **CA-06:** comprobar que el contenedor se detiene y reinicia con el procedimiento definido y que el servicio vuelve a responder.

### T-09: Verificar las operaciones del servicio

- [x] Comprobar que el contenedor pueda iniciarse correctamente.
- [x] Comprobar que el contenedor pueda detenerse con `docker compose stop`.
- [x] Comprobar que el contenedor pueda reiniciarse con `docker compose start` o `docker compose restart`.
- [x] Verificar que el servicio siga funcionando después de reiniciarlo.
- [x] Confirmar que la implementación cumple los requisitos de `spec.md` y los principios de `constitution.md`.

## Criterio de finalización

La feature se considera completada cuando todas las tareas están verificadas, todos los criterios de aceptación se cumplen y la implementación respeta las especificaciones y los principios del proyecto.
