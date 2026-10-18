# Especificación: Servidor Nginx

## 1. Objetivo

Definir los requisitos funcionales y operativos de un servidor web Nginx ejecutado dentro de un contenedor Docker.

## 2. Alcance

El servidor permitirá atender solicitudes HTTP y entregar contenido web estático. Su ejecución y configuración se gestionarán mediante Docker.

## 3. Requisitos funcionales

### RF-01: Atender solicitudes HTTP
El servidor deberá aceptar solicitudes HTTP a través del puerto publicado por Docker y responder con el contenido correspondiente.
el dominio sera `local.test`

### RF-02: Entregar contenido estático
El servidor deberá servir los archivos estáticos disponibles en el directorio web configurado.

### RF-03: Responder a la página principal
Cuando un cliente solicite la ruta `/`, el servidor deberá devolver la página principal del sitio web.

### RF-04: Gestionar recursos inexistentes
Cuando un cliente solicite un recurso inexistente, el servidor deberá responder con el código HTTP `404 Not Found`.

## 4. Requisitos operativos

### RO-01: Ejecución en Docker
El servidor deberá ejecutarse dentro de un contenedor Docker.

### RO-02: Persistencia de la configuración
La configuración personalizada y el contenido web deberán poder mantenerse fuera del ciclo de vida del contenedor, mediante los mecanismos de montaje definidos para el proyecto.

### RO-03: Reinicio del servicio
El contenedor deberá poder detenerse y reiniciarse siguiendo el procedimiento de operación definido para el proyecto.

## 5. Criterios de aceptación
- CA-01: Una solicitud a `/` devuelve HTTP `200 OK` y la página principal esperada.
- CA-02: Una solicitud a un recurso inexistente devuelve HTTP `404 Not Found`.
- CA-03: El servidor responde correctamente desde el puerto publicado por Docker.
- CA-04: Los archivos de configuración y contenido persisten después de recrear el contenedor, cuando se utilizan los montajes definidos.