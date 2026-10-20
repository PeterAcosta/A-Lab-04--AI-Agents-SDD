# Plan: Servidor web Nginx en Docker

## 1. Referencias

- Especificación: `specs/features/001-nginx/spec.md`
- Constitución: `specs/constitution.md`
- Flujo de trabajo: `AGENTS.md`
- Variables de entorno: `./.env`

La implementación debe cumplir la especificación y respetar la constitución del proyecto.

## 2. Enfoque técnico

Construir una imagen propia a partir de la imagen oficial `nginx:1.28.0-bookworm`, con `logrotate` y `cron` instalados mediante `apt`. Docker Compose construye la imagen, publica el puerto de `.env`, monta los tres volúmenes e inyecta `APP_MESSAGE`.

El entrypoint del proyecto prepara los archivos de ejecución, arranca `cron` y delega en el entrypoint oficial de la imagen para conservar su comportamiento. Nginx sirve el sitio estático y las páginas de error personalizadas; `logrotate` rota los logs escritos en el volumen.

## 3. Arquitectura y estructura

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
├── vol-01-nginx-conf.d/
│   └── test.local.conf
├── vol-01-nginx-logs/          # generado en tiempo de ejecución
└── vol-01-nginx-web/
    ├── index.html
    ├── 404.html
    ├── 500.html
    └── message.html            # generado por el entrypoint
```

### Responsabilidades

- `docker-compose.yaml`: construye la imagen, publica `${NGINX_HOST_PORT}:80`, monta los volúmenes e inyecta `APP_MESSAGE`.
- `docker/Dockerfile.01-nginx`: parte de la imagen oficial, instala `logrotate` y `cron`, copia configuraciones y declara el entrypoint y el comando.
- `docker/entrypoint.01-nginx.sh`: valida `APP_MESSAGE`, genera `message.html`, arranca `cron` y ejecuta el entrypoint oficial con el comando del contenedor.
- `docker/logrotate.01-nginx.conf`: reglas de rotación de `/var/log/nginx/*.log`.
- `docker/cron.01-nginx`: programación diaria de `logrotate`.
- `vol-01-nginx-conf.d/test.local.conf`: servidor virtual de `test.local`, páginas de error y ruta de verificación de 500.
- `vol-01-nginx-web/index.html`: página principal; incluye el mensaje fijo y el fragmento generado con `APP_MESSAGE`.
- `vol-01-nginx-web/404.html`: página de error 404.
- `vol-01-nginx-web/500.html`: página de error 500.
- `README.md`: comandos para iniciar, verificar, rotar logs y detener el servicio.

## 4. Decisiones técnicas

### DT-01: Imagen de Nginx

Usar la imagen oficial `nginx:1.28.0-bookworm`, con etiqueta fija para reproducibilidad. La variante Debian permite instalar `logrotate` y `cron` con `apt-get install -y --no-install-recommends` y eliminar las listas de paquetes en la misma capa. La instalación se ejecuta con `DEBIAN_FRONTEND=noninteractive`.

### DT-02: Publicación del puerto

Nginx escucha en el puerto `80` dentro del contenedor. Compose publica `${NGINX_HOST_PORT}` del host y lo conecta al `80` del contenedor mediante `ports: ["${NGINX_HOST_PORT}:80"]`. El valor por defecto de `.env` es `8080`.

Un cambio en `NGINX_HOST_PORT` exige recrear el contenedor con `docker compose up -d`; Compose detecta el cambio de configuración y vuelve a crear el servicio. La URL de acceso es `http://test.local:${NGINX_HOST_PORT}/`.

### DT-03: Configuración del sitio y páginas de error

`vol-01-nginx-conf.d/test.local.conf` se monta en `/etc/nginx/conf.d/` y contiene:

```nginx
server {
    listen 80;
    server_name test.local;
    root /var/www/x-site;
    index index.html;
    ssi on;

    error_page 404 /404.html;
    error_page 500 502 503 504 /500.html;

    location = /404.html { internal; }
    location = /500.html { internal; }

    location = /__verificacion/500 { return 500; }
}
```

El montaje del volumen oculta el `default.conf` de la imagen; por eso la configuración debe ser autosuficiente. La ruta `/__verificacion/500` existe únicamente para verificar CA-07 y se documenta en el README.

### DT-04: Volúmenes

- `./vol-01-nginx-conf.d:/etc/nginx/conf.d:ro`: la configuración se edita en el host y el contenedor solo la lee.
- `./vol-01-nginx-logs:/var/log/nginx`: logs en el host, con escritura para Nginx y `logrotate`.
- `./vol-01-nginx-web:/var/www/x-site`: contenido editable en el host; el entrypoint escribe `message.html` en este volumen.

El montaje de `/var/log/nginx` oculta los enlaces simbólicos que la imagen oficial crea hacia `stdout`/`stderr`; Nginx escribe entonces archivos reales, requisito para que `logrotate` opere. Consecuencia: los accesos no aparecen en `docker compose logs`; se consultan en `./vol-01-nginx-logs/`.

### DT-05: Entrypoint

`docker/entrypoint.01-nginx.sh` se ejecuta como `ENTRYPOINT`, se copia con permisos de ejecución y el comando del contenedor sigue siendo `nginx -g 'daemon off;'`. El script:

1. Falla si `APP_MESSAGE` no está definida.
2. Asegura `/var/log/nginx` y `/var/www/x-site`.
3. Genera `/var/www/x-site/message.html` con `APP_MESSAGE` escapado para HTML.
4. Arranca `cron` como demonio.
5. Ejecuta `exec /docker-entrypoint.sh "$@"` para conservar los scripts de inicialización de la imagen oficial.

### DT-06: Mensaje desde APP_MESSAGE

`index.html` contiene el título, el mensaje fijo y la directiva SSI `<!--# include virtual="/message.html" -->`. El entrypoint regenera `message.html` en cada arranque, de modo que un cambio en `APP_MESSAGE` se refleja al reiniciar el contenedor. `index.html` no se sobrescribe, por lo que CA-04 sigue siendo válido.

`message.html` es un archivo generado: se documenta en el README y no se edita a mano. El entrypoint escapa `&`, `<` y `>` para evitar inyección de HTML desde `.env`.

### DT-07: Rotación de logs

Se instala `docker/logrotate.01-nginx.conf` como `/etc/logrotate.d/nginx`:

```
/var/log/nginx/*.log {
    daily
    maxsize 10M
    rotate 7
    missingok
    notifempty
    compress
    delaycompress
    sharedscripts
    postrotate
        [ -f /var/run/nginx.pid ] && kill -USR1 "$(cat /var/run/nginx.pid)"
    endscript
}
```

`docker/cron.01-nginx` se instala como `/etc/cron.d/nginx-logrotate` con permisos `0644` y ejecuta `logrotate` a diario. El entrypoint arranca `cron`. La rotación forzada con `logrotate -f` se usa en la verificación de CA-08.

### DT-08: Nombre de imagen y servicio

Compose usa el servicio `nginx`, el contenedor `03-nginx` y la imagen `03-nginx-image:01`, construida con `build.context: .` y `build.dockerfile: docker/Dockerfile.01-nginx`. No se usa la clave `version`, obsoleta en Compose v2+.

### DT-09: Documentación

`README.md` incluye:

- Requisitos: Docker Engine, Docker Compose y `test.local` definido en `/etc/hosts`.
- Arranque: `docker compose up -d --build`.
- Verificación: `docker compose ps`, `curl -i http://test.local:8080/`, `curl -i http://test.local:8080/no-existe`, `curl -i http://test.local:8080/__verificacion/500`.
- Cambio de puerto y de `APP_MESSAGE` con reinicio.
- Rotación forzada de logs y ubicación del volumen.
- Parada y eliminación: `docker compose stop` y `docker compose down`.
- Nota sobre `message.html` generado y sobre los logs fuera de `docker compose logs`.

No se documentan ni copian secretos; los valores ficticios de `.env` son la única fuente de configuración.

## 5. Estrategia de implementación

0. Redactar `tasks.md` a partir de esta especificación y este plan, y aprobarlo antes de escribir código.
1. Crear la estructura de directorios y los archivos estáticos.
2. Crear `docker/Dockerfile.01-nginx`.
3. Crear `docker/entrypoint.01-nginx.sh`, `docker/logrotate.01-nginx.conf` y `docker/cron.01-nginx`.
4. Crear `vol-01-nginx-conf.d/test.local.conf`.
5. Crear `docker-compose.yaml`.
6. Crear `index.html`, `404.html` y `500.html`.
7. Documentar los comandos en `README.md`.
8. Ejecutar `docker compose up -d --build` y verificar los criterios de aceptación.
9. Corregir los problemas detectados y repetir las verificaciones.

## 6. Estrategia de verificación

Las pruebas se ejecutan desde la raíz del proyecto y se registran con el comando y su salida:

- `docker compose ps` → **CA-01**: servicio `nginx` en estado `running`.
- `docker compose port nginx 80` → **CA-02**: puerto del host igual a `NGINX_HOST_PORT`.
- `curl -i http://test.local:8080/` → **CA-02 y CA-03**: `200 OK` con el título, el mensaje fijo y el valor de `APP_MESSAGE`.
- `curl -i http://test.local:8080/no-existe` → **CA-06**: `404` con `Página no encontrada`.
- `curl -i http://test.local:8080/__verificacion/500` → **CA-07**: `500` con `Error interno del servidor`.
- Editar `vol-01-nginx-web/index.html`, repetir el `curl` y comprobar el cambio sin reiniciar → **CA-04**.
- `docker compose stop` y `docker compose start` → **CA-05**: el sitio vuelve a responder.
- Generar una solicitud, ejecutar `docker compose exec nginx logrotate -f /etc/logrotate.d/nginx` y comprobar el archivo rotado en `./vol-01-nginx-logs/` sin perder el servicio → **CA-08**.
- Cambiar `NGINX_HOST_PORT` en `.env` (por ejemplo a `8081`), ejecutar `docker compose up -d`, comprobar `http://test.local:8081/` y restaurar el valor original → **CA-09**.
- `docker compose exec nginx nginx -t` → configuración válida; soporte de CA-02, CA-06 y CA-07.

Cada criterio de aceptación debe quedar cubierto por al menos una prueba registrada. Los resultados se reflejan en `tasks.md` y, al final, en `z-report.md`.

## 7. Riesgos y mitigaciones

- **Puerto ocupado:** cambiar `NGINX_HOST_PORT` en `.env` antes del arranque.
- **`APP_MESSAGE` con HTML:** el entrypoint escapa `&`, `<` y `>`; se documenta que el valor es texto.
- **`default.conf` oculto:** la configuración montada es autosuficiente y se valida con `nginx -t`.
- **Logs fuera de `docker compose logs`:** consecuencia del montaje; se documenta y se consulta el volumen.
- **`logrotate`/`cron` en el contenedor:** `cron` se arranca en el entrypoint y la rotación se prueba de forma forzada.
- **Etiqueta de imagen:** `nginx:1.28.0-bookworm` está fijada; la descarga no se ha ejecutado todavía y se comprobará en la implementación.
- **SSI:** el módulo está incluido en la imagen oficial; se comprueba con `nginx -t` y con la respuesta HTTP.
- **Permisos de volúmenes:** los archivos generados por el entrypoint se crean como `root`; el README indica cómo consultarlos.

## 8. Criterio de finalización

El plan se considerará implementado cuando todas las tareas de `tasks.md` estén completadas y los criterios de aceptación de `spec.md` hayan sido verificados satisfactoriamente, con evidencia registrada.

Si durante la implementación se detecta una contradicción con la especificación, se deberá resolver mediante el procedimiento de cambios definido por el proyecto, sin introducir desviaciones silenciosas.
