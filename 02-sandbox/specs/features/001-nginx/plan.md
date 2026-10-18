

# Plan de implementación: Servidor Nginx

## 1. Enfoque técnico

El servidor web se implementará utilizando Nginx dentro de un contenedor Docker, con configuración y contenido web externos al contenedor cuando corresponda.

## 2. Arquitectura
- **Servidor web:** Nginx.
- **Contenedorización:** Docker.
- **imagen:** `nginx:1.31.7-alpine3.24`

**Dockerfile:** `./docker/Dockerfile.01-nginx`
**entrypoint:** `./docker/entrypoint.01-nginx.sh`
**orquestador:** `./docker-compose.yaml`
**nombre de la imagen resultante:** `01-nginx-image` y tag`01`
**nombre del contenedor resultante:** `01-nginx`

**puerto de nginx:** leerlo del archivo `./.env` e inyectar esa variable dentro del contenedor, al final del proceso el servidor nginx debe escuchar si o si en ese puerto

**variables de entorno dentro del contenedor:** 
- El Dockerfile define dentro del contenedor una variable `image_name`con el nombre de la imagen base utilizada 
- El Dockerfile define dentro del contenedor una variable `nginx_port` obtenida del archivo `.env`
**dominio de nginx:** el servidor responde al dominiuo `test.local`

**volumenes docker:** dos, uno a la raiz del sitio `test.local` dentro del contenedor, otro a la configuracion de nginx del dominio antes mensionado, asi :
volumes:
  - ./docker/test.local/:/usr/share/nginx/html
  - ./docker/etc--nginx--conf.d/:/etc/nginx/conf.d/

**paginas html5:** se haran dos paginas web estaticas y muy simples en la raiz del sitio `test.local`, una sera el `index.html` y otra sera el `404.html`

**borrar lo que hiciste como auxiliar**: despues de terminar tu trabajo borra las imagenes, contenedores, redes y volumenes que te hayan servido de auxiliar, no toques nada que tu no hayas creado. La imagen y el contenedor finales de la feature deben conservarse  


## 6. Consideraciones técnicas
La implementación deberá respetar los requisitos de `spec.md` y los principios establecidos en `constitution.md`.