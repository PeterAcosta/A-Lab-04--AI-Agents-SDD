# Plan: Servidor web Nginx en Docker

## 1. Referencias

- Especificación: `specs/features/001-nginx/spec.md`
- Constitución: `specs/constitution.md`

La implementación debe cumplir la especificación y respetar la constitución del proyecto.

## 2. Enfoque técnico

Implementar un servidor web estático mediante un contenedor Docker que ejecute la imagen oficial de Nginx.

Docker Compose gestionará el servicio, la publicación del puerto HTTP y el montaje del contenido web desde el host.

## 3. Arquitectura y estructura



- COnfigura "Logrotate"  para manejar los logs del contenedor y de nginx 




### Responsabilidades

- `docker-compose.yaml`: define el servicio Nginx, la publicación del puerto y el montaje del contenido.
- `html/`: contiene los archivos estáticos del sitio web.
- `html/index.html`: proporciona la página principal.
- `README.md`: documenta cómo iniciar, verificar y detener el servicio.

## 4. Decisiones técnicas

### DT-01: Imagen de Nginx

Utilizar una imagen oficial de Nginx con una etiqueta estable explícita, evitando depender de una etiqueta flotante si el proyecto requiere reproducibilidad.

### DT-02: Publicación del puerto

el puerto definido en `./.env` debe usarse para el servidor nginx
Mapear ese puerto del host al puerto `80` del contenedor mediante Docker Compose.









### DT-04: Configuración de Nginx

Utilizar la configuración predeterminada de la imagen oficial, siempre que satisfaga la especificación. No añadir archivos de configuración personalizados sin una necesidad concreta.

### DT-05: Persistencia

Mantener los archivos HTML en el host para que sus modificaciones estén disponibles sin reconstruir la imagen.

## 5. Estrategia de implementación

La implementación seguirá este orden:

1. Crear la estructura de directorios.
2. Crear la página principal `index.html` y `404.html` y errores 500 en `505n.html`
3. Definir el servicio en `docker-compose.yaml`.
4. Documentar los comandos de operación en `README.md`.
5. Iniciar el servicio y comprobar su funcionamiento.
6. Corregir los problemas detectados y repetir las verificaciones.

## 6. Estrategia de verificación

Verificar la solución mediante pruebas reproducibles:

- Confirmar que el contenedor está en ejecución.
- Comprobar que el puerto del host está publicado.
- Realizar una solicitud HTTP a `http://test.local/`.
- Confirmar que la respuesta contiene el título y el mensaje definidos en la especificación.
- Modificar `index.html` y comprobar que el cambio se refleja en la respuesta.
- Detener y reiniciar el servicio y comprobar que vuelve a responder correctamente.

Los resultados deben evaluarse contra los criterios de aceptación de `spec.md`.


## 8. Criterio de finalización

El plan se considerará implementado cuando todas las tareas asociadas estén completadas y los criterios de aceptación de `spec.md` hayan sido verificados satisfactoriamente.

Si durante la implementación se detecta una contradicción con la especificación, se deberá resolver mediante el procedimiento de cambios definido por el proyecto, sin introducir desviaciones silenciosas.