# Spec: Servidor web Nginx en Docker

## 1. Objetivo

Crear un contenedor Docker que ejecute un servidor web Nginx y permita servir contenido HTML estático mediante HTTP.



## 2. Alcance

La implementación incluye:

- Un contenedor Docker que ejecute Nginx.
- Un sitio web estático con una página `index.html`  y otra `404.html`
- Acceso al sitio mediante HTTP desde el host.
- Configuración reproducible del entorno mediante archivos del proyecto.

Quedan fuera del alcance:

- HTTPS y certificados TLS.
- Dominios personalizados.
- Aplicaciones dinámicas y bases de datos.
- Balanceo de carga y múltiples réplicas.

## 3. Estructura

- escribe `docker-compose.yaml` para el compositor
- `./docer/Dockerfile.01-nginx`
- `entrypoint.01-nginx.sh` el entrypoint debe ser usado e incluido por el Dockerfile

Dentro del contenedor instala "logrotate" que rote los logs generados y que los mantenga pequeños para ahorrar espacio.

crea los volumen de docker entre el interior del contenedor y el host 
- entre `./vol-01-nginx-conf.d/` y la carpeta donde nginx dentro del contenedor guarda sus archivos de configuracion de sitios webs a los que sirve.
- entre `./vol-01-nginx-logs/` y la carpeta donde el contenedor guarda sus archivos de logs ( la cual debe ser limpiada perioidamente por logrotate)
- entre `./vol-01-nginx-web/` y la carpeta  `/var/www/x-site/` 

El servidor nginx debe tener una configuracion para servir al dominio `test.local`, el que debe apuntar a los archivos de la carpeta `/var/www/x-site/` (document root)

Escribe un `index.html`  y un `404.html`  en `/var/www/x-site/` dentro del contenedor 

Escribe - `README.md`: instrucciones para iniciar, verificar y detener el servicio.


### RF-01: Ejecutar Nginx

El sistema debe iniciar un contenedor Docker que ejecute un servidor Nginx operativo.

### RF-02: Exponer el puerto HTTP

El servidor debe escuchar en el puerto detallado en el archivo `.env` del contenedor y exponer ese mismo puerto en el host.
Si el usuario cambia el valor en en archivo `.end` la proxima vex que se levante el contenedor el cambio se debe ver reflejado.

El puerto abierto del host debe estar publicado y conectado al puerto `80` del contenedor.

### RF-03: Servir contenido web

El servidor nginx debe tener una configuracion para servir al dominio `test.local`, el que debe apuntar a los archivos de la carpeta `/var/www/x-site/` (document root)
( `test.local` ya esta definido en `/etc/hosts`)

Escribe un `index.html`  y un `404.html`  en `/var/www/x-site/` dentro del contenedor .

El servidor debe entregar el archivo `index.html` como página principal al recibir una solicitud HTTP `GET /`.

### RF-04: Mostrar contenido identificable

La página principal debe mostrar el título `Servidor Nginx en Docker` y un mensaje que confirme que el servidor está funcionando.

### RF-05: Permitir detener y reiniciar el servicio

El contenedor debe poder detenerse y volver a iniciarse mediante los mecanismos habituales de Docker, sin necesidad de reconstruir la imagen cuando no haya cambios en ella.

## 4. Requisitos no funcionales

### RNF-01: Reproducibilidad

La configuración necesaria para crear y ejecutar el servicio debe estar documentada y almacenada en los archivos del proyecto.

### RNF-02: Mantenibilidad

La solución debe utilizar una configuración sencilla, adecuada para un entorno de aprendizaje y fácil de modificar.

### RNF-03: Persistencia del contenido

El contenido del sitio debe mantenerse disponible en los archivos del proyecto, de modo que pueda modificarse sin editar manualmente el interior del contenedor.

### RNF-04: Compatibilidad

La solución debe funcionar en un entorno Linux con Docker Engine y Docker Compose instalados.

## 5. Restricciones técnicas

- Utilizar una imagen oficial de Nginx.
- Utilizar HTTP sin TLS.
- No incorporar dependencias innecesarias.
- Respetar los principios y las restricciones definidos en `specs/constitution.md`.

## 6. Criterios de aceptación

### CA-01: Contenedor en ejecución

Dado que Docker está disponible y el puerto requerido está libre, cuando se inicie el servicio, entonces el contenedor debe quedar en estado de ejecución.

### CA-02: Acceso HTTP

Dado que el contenedor está en ejecución, cuando se solicite `http://test.local/`, entonces el servidor debe responder con HTTP `200 OK`.

### CA-03: Contenido correcto

Dado que se solicita la página principal, entonces la respuesta debe contener el título `Servidor Nginx en Docker` y el mensaje de funcionamiento definido en RF-04.

### CA-04: Persistencia de archivos

Dado que se modifica el archivo `index.html` del proyecto, cuando se vuelva a solicitar la página, entonces el servidor debe entregar el contenido actualizado sin necesidad de modificar manualmente el interior del contenedor.

### CA-05: Reinicio del servicio

Dado que el contenedor se ha detenido, cuando se vuelva a iniciar, entonces debe poder servir nuevamente la página principal.




Los archivos adicionales necesarios deberán justificarse por una necesidad concreta.

## 8. Verificación

La implementación se considerará terminada cuando se hayan comprobado los criterios de aceptación mediante pruebas reproducibles.

Como mínimo, se debe verificar:

- El estado del contenedor.
- La publicación del puerto definido en `./.env`.
- La respuesta HTTP de `http://test.local/`.
- El contenido de la página.
- La actualización del contenido y el reinicio del servicio.

## 9. Decisiones de implementación

Los detalles de implementación que no estén fijados por esta especificación podrán definirse durante la elaboración de `plan.md`, siempre que respeten esta especificación y la constitución del proyecto.

Si una decisión requiere modificar un requisito o criterio de aceptación, se deberá actualizar primero la especificación mediante el procedimiento de cambios definido por el proyecto.