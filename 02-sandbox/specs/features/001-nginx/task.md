# Tareas de implementación: Servidor Nginx

## Referencias

- `spec.md`: requisitos funcionales, operativos y criterios de aceptación.
- `plan.md`: arquitectura y decisiones técnicas.
- `constitution.md`: principios y reglas obligatorias del proyecto.

## Tareas

### T-01: Revisar las especificaciones

- [ ] Leer `constitution.md` y verificar sus principios.
- [ ] Revisar `spec.md` y `plan.md`.
- [ ] Comprobar la estructura existente del proyecto y respetar sus convenciones.

### T-02: Crear el Dockerfile

- [ ] Crear `./docker/Dockerfile.01-nginx`.
- [ ] Utilizar la imagen base `nginx:1.31.7-alpine3.24`.
- [ ] Definir las variables de entorno necesarias para identificar la imagen y configurar el puerto de Nginx.
- [ ] Preparar la imagen para su construcción con el nombre `01-nginx`.

### T-03: Preparar la configuración de Nginx

- [ ] Crear la configuración personalizada para el dominio `local.test`.
- [ ] Definir el directorio raíz del sitio web.
- [ ] Configurar `index.html` como página principal.
- [ ] Configurar la respuesta `404 Not Found` para los recursos inexistentes.
- [ ] Preparar la configuración para utilizar el puerto definido mediante las variables de entorno.

### T-04: Crear el entrypoint

- [ ] Crear `./docker/entrypoint.01-nginx.sh`.
- [ ] Preparar la configuración de Nginx utilizando las variables de entorno necesarias.
- [ ] Garantizar que Nginx se ejecute en primer plano dentro del contenedor.
- [ ] Verificar que el script pueda ejecutarse correctamente al iniciar el contenedor.

### T-05: Crear el contenido web

- [ ] Crear el directorio raíz del sitio `local.test`.
- [ ] Crear `index.html` con una página HTML5 estática, simple y válida.
- [ ] Crear `404.html` con una página HTML5 estática para los recursos inexistentes.

### T-06: Configurar Docker Compose

- [ ] Crear o actualizar `./docker-compose.yaml`.
- [ ] Definir la construcción de la imagen utilizando `./docker/Dockerfile.01-nginx`.
- [ ] Asignar a la imagen construida el nombre `01-nginx`.
- [ ] Leer del archivo `./.env` el puerto configurado para Nginx.
- [ ] Inyectar en el contenedor las variables de entorno necesarias.
- [ ] Publicar el puerto correspondiente para permitir el acceso desde el host.
- [ ] Configurar un volumen para el contenido web.
- [ ] Configurar un segundo volumen para la configuración de Nginx.
- [ ] Verificar que la configuración y el contenido puedan mantenerse al recrear el contenedor.

### T-07: Verificar el acceso al dominio

- [ ] Comprobar que el servidor responda al dominio `local.test`.
- [ ] Verificar que el dominio pueda resolverse correctamente desde el host.
- [ ] Comprobar el acceso al servidor mediante el puerto publicado por Docker.

### T-08: Validar los criterios de aceptación

- [ ] **CA-01:** comprobar que una solicitud a `/` devuelve HTTP `200 OK` y muestra la página principal esperada.
- [ ] **CA-02:** comprobar que una solicitud a un recurso inexistente devuelve HTTP `404 Not Found`.
- [ ] **CA-03:** comprobar que el servidor responde correctamente desde el puerto publicado por Docker.
- [ ] **CA-04:** comprobar que la configuración y el contenido persisten después de recrear el contenedor utilizando los volúmenes definidos.

### T-09: Verificar las operaciones del servicio

- [ ] Comprobar que el contenedor pueda iniciarse correctamente.
- [ ] Comprobar que el contenedor pueda detenerse y reiniciarse siguiendo el procedimiento definido para el proyecto.
- [ ] Verificar que el servicio siga funcionando después de reiniciarlo.
- [ ] Confirmar que la implementación cumple los requisitos de `spec.md` y los principios de `constitution.md`.

## Criterio de finalización

La feature se considera completada cuando todas las tareas están verificadas, todos los criterios de aceptación se cumplen y la implementación respeta las especificaciones y los principios del proyecto.