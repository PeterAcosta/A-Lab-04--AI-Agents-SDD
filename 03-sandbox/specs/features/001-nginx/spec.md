# Spec: Servidor web Nginx en Docker

## 1. Objetivo

Crear un contenedor Docker que ejecute un servidor web Nginx y permita servir contenido HTML estático mediante HTTP, con configuración reproducible y rotación de logs.

## 2. Alcance

La implementación incluye:

- Un contenedor Docker que ejecute Nginx.
- Un sitio web estático con `index.html`, `404.html` y `500.html`.
- Acceso al sitio mediante HTTP desde el host.
- Configuración reproducible del entorno mediante archivos del proyecto.
- Rotación de logs dentro del contenedor mediante `logrotate`.
- Acotar el tamaño de los logs generados por el contenedor.

Quedan fuera del alcance:

- HTTPS y certificados TLS.
- Dominios personalizados.
- Aplicaciones dinámicas y bases de datos.
- Balanceo de carga y múltiples réplicas.
- Logs del daemon de Docker y del sistema operativo host.

## 3. Estructura

- `docker-compose.yaml`: define el servicio, el puerto publicado y los volúmenes.
- `docker/Dockerfile.01-nginx`: construye la imagen a partir de la imagen oficial de Nginx.
- `docker/entrypoint.01-nginx.sh`: entrypoint del contenedor; el Dockerfile debe incluirlo y usarlo.
- `docker/logrotate.01-nginx.conf`: configuración de rotación de logs.
- `docker/cron.01-nginx`: programación periódica de `logrotate`.
- `.env`: define `NGINX_HOST_PORT` y `APP_MESSAGE`.

Volúmenes entre el contenedor y el host:

- `./vol-01-nginx-conf.d/` → `/etc/nginx/conf.d/`: configuración de sitios; contiene `test.local.conf`.
- `./vol-01-nginx-logs/` → `/var/log/nginx/`: logs de Nginx y salida de la tarea de rotación, rotados por `logrotate`.
- `./vol-01-nginx-web/` → `/var/www/x-site/`: document root.

El montaje de `./vol-01-nginx-conf.d/` oculta el `default.conf` de la imagen; `test.local.conf` debe ser autosuficiente.

El servidor Nginx debe tener una configuración para servir al dominio `test.local`, apuntando al document root `/var/www/x-site/`.

Archivos del sitio:

- `index.html`: página principal.
- `404.html`: página de error 404; debe incluir el texto `Página no encontrada`.
- `500.html`: página de error 500; debe incluir el texto `Error interno del servidor`.

Documentación:

- `README.md`: instrucciones para iniciar, verificar y detener el servicio.

Los archivos `docker/logrotate.01-nginx.conf` y `docker/cron.01-nginx` se justifican por la rotación de logs exigida en RF-07.

## 4. Requisitos funcionales

### RF-01: Ejecutar Nginx

El sistema debe iniciar un contenedor Docker que ejecute un servidor Nginx operativo.

### RF-02: Exponer el puerto HTTP

Nginx debe escuchar en el puerto `80` dentro del contenedor. Docker Compose debe publicar en el host el puerto definido por `NGINX_HOST_PORT` en `.env` y conectarlo al puerto `80` del contenedor.

Si se modifica `NGINX_HOST_PORT`, al volver a levantar el servicio con `docker compose up -d` el nuevo puerto debe quedar publicado.

La URL de acceso es `http://test.local:<NGINX_HOST_PORT>/`.

### RF-03: Servir contenido web

Nginx debe servir el dominio `test.local` con document root `/var/www/x-site/` y entregar `index.html` como página principal al recibir `GET /`.

### RF-04: Mostrar contenido identificable

La página principal debe mostrar:

- El título `Servidor Nginx en Docker`.
- El mensaje fijo `El servidor está funcionando correctamente.`.
- El valor de la variable `APP_MESSAGE` definida en `.env`, leído al iniciar el contenedor.

### RF-05: Páginas de error personalizadas

Nginx debe entregar `404.html` ante una ruta inexistente y `500.html` ante un error interno, en lugar de sus páginas de error por defecto.

### RF-06: Permitir detener y reiniciar el servicio

El contenedor debe poder detenerse y volver a iniciarse mediante los mecanismos habituales de Docker, sin necesidad de reconstruir la imagen cuando no haya cambios en ella.

### RF-07: Rotar logs

El contenedor debe instalar `logrotate` y ejecutarlo periódicamente para rotar los archivos de `/var/log/nginx/`, limitando el espacio ocupado y conservando un historial acotado de logs. La salida de la tarea de rotación debe registrarse en un archivo dentro del volumen de logs y quedar sujeta a la misma rotación.

### RF-08: Acotar logs del contenedor

Los logs que el contenedor escribe en stdout/stderr deben quedar limitados por el driver de Docker configurado en `docker-compose.yaml`, con un tamaño máximo y un número máximo de archivos.

## 5. Requisitos no funcionales

### RNF-01: Reproducibilidad

La configuración necesaria para crear y ejecutar el servicio debe estar documentada y almacenada en los archivos del proyecto, con la imagen base fijada por etiqueta y las dependencias del sistema declaradas de forma explícita.

### RNF-02: Mantenibilidad

La solución debe utilizar una configuración sencilla, adecuada para un entorno de aprendizaje y fácil de modificar.

### RNF-03: Persistencia del contenido

El contenido del sitio debe mantenerse disponible en los archivos del proyecto, de modo que pueda modificarse sin editar manualmente el interior del contenedor.

### RNF-04: Compatibilidad

La solución debe funcionar en un entorno Linux con Docker Engine y Docker Compose instalados.

## 6. Restricciones técnicas

- Utilizar una imagen oficial de Nginx.
- Utilizar HTTP sin TLS.
- No incorporar dependencias innecesarias; `logrotate` y `cron` se justifican por RF-07.
- Respetar los principios y las restricciones definidos en `specs/constitution.md`.

## 7. Criterios de aceptación

### CA-01: Contenedor en ejecución

Dado que Docker está disponible y el puerto requerido está libre, cuando se inicie el servicio, entonces el contenedor debe quedar en estado de ejecución.

### CA-02: Acceso HTTP

Dado que el contenedor está en ejecución, cuando se solicite `http://test.local:8080/` (o el puerto vigente de `NGINX_HOST_PORT`), entonces el servidor debe responder con HTTP `200 OK`.

### CA-03: Contenido correcto

Dado que se solicita la página principal, entonces la respuesta debe contener el título `Servidor Nginx en Docker`, el mensaje fijo `El servidor está funcionando correctamente.` y el valor de `APP_MESSAGE` definido en `.env`.

### CA-04: Persistencia de archivos

Dado que se modifica el archivo `index.html` del proyecto, cuando se vuelva a solicitar la página, entonces el servidor debe entregar el contenido actualizado sin necesidad de modificar manualmente el interior del contenedor.

### CA-05: Reinicio del servicio

Dado que el contenedor se ha detenido, cuando se vuelva a iniciar, entonces debe poder servir nuevamente la página principal.

### CA-06: Página 404 personalizada

Dado que el contenedor está en ejecución, cuando se solicite una ruta inexistente como `http://test.local:8080/no-existe`, entonces la respuesta debe ser HTTP `404` y contener el texto `Página no encontrada` de `404.html`.

### CA-07: Página 500 personalizada

Dado que el contenedor está en ejecución, cuando se solicite la ruta de verificación `http://test.local:8080/__verificacion/500`, entonces la respuesta debe ser HTTP `500` y contener el texto `Error interno del servidor` de `500.html`.

### CA-08: Rotación de logs

Dado que se generaron logs en `/var/log/nginx/`, cuando se ejecute `logrotate -f /etc/logrotate.d/nginx` dentro del contenedor, entonces debe existir un archivo de log rotado y el servicio debe seguir respondiendo.

### CA-09: Cambio de puerto

Dado que se modifica `NGINX_HOST_PORT` en `.env`, cuando se ejecute `docker compose up -d`, entonces el nuevo puerto debe quedar publicado y responder a las solicitudes HTTP.

### CA-10: Logs del contenedor acotados

Dado que el contenedor está en ejecución, cuando se inspeccione su configuración con `docker inspect`, entonces el driver de logs debe ser `json-file` y debe incluir los límites `max-size` y `max-file` declarados en `docker-compose.yaml`; `docker compose logs` debe seguir mostrando la salida del contenedor.

### CA-11: Registro de la rotación

Dado que se ejecuta la tarea de rotación, entonces su salida debe quedar registrada en `/var/log/nginx/logrotate-cron.log` y el archivo debe estar cubierto por el patrón de rotación.

## 8. Verificación

La implementación se considerará terminada cuando se hayan comprobado los criterios de aceptación mediante pruebas reproducibles.

Como mínimo, se debe verificar:

- El estado del contenedor.
- La publicación del puerto definido en `./.env` y su cambio.
- La respuesta HTTP `200` de `http://test.local:8080/`.
- El título, el mensaje fijo y el valor de `APP_MESSAGE` en la página.
- La página `404` personalizada.
- La página `500` personalizada.
- La actualización de `index.html` y el reinicio del servicio.
- La rotación forzada de logs.
- El registro de la tarea de rotación.
- La configuración de límites de logs del contenedor.

Los resultados deben quedar registrados con los comandos ejecutados y sus salidas.

## 9. Decisiones de implementación

Los detalles de implementación que no estén fijados por esta especificación podrán definirse durante la elaboración de `plan.md`, siempre que respeten esta especificación y la constitución del proyecto.

Si una decisión requiere modificar un requisito o criterio de aceptación, se deberá actualizar primero la especificación mediante el procedimiento de cambios definido por el proyecto.
