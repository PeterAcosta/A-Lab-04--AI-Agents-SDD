# Tasks: 001-nginx

Orden obligatorio. Marcar `[x]` solo tras verificar. La evidencia y las limitaciones están en `z-report.md`. No ejecutar Git ni tocar el host; `.env` solo se modifica temporalmente en T-13.

| ID | Tarea | Verificación | CA | Estado |
|---|---|---|---|---|
| T-01 | Estructura; `.env`; `test.local`; logs `755`; `APP_MESSAGE` sin `&<>`. | Directorios, variables, `stat`, `getent`. | — | [x] |
| T-02 | `logrotate` `10M`/`3`; cron horario a `logrotate-cron.log`. | `grep` de configuración. | — | [x] |
| T-03 | Entrypoint: `message.html`, cron, `entrypoint: listo`, exec oficial. | `sh -n`; prueba de mensaje. | — | [x] |
| T-04 | Dockerfile con digest; `logrotate` y `cron` por `apt`. | Build, binarios, versiones. | — | [x] |
| T-05 | `test.local.conf` con errores y ruta 500. | `nginx -t`, `grep`, `stat 644`. | — | [x] |
| T-06 | `index.html`, `404.html`, `500.html`. | `grep`, `stat 644`. | — | [x] |
| T-07 | Compose: puerto, volúmenes, `APP_MESSAGE`, logging. | `docker compose config`. | — | [x] |
| T-08 | README de operación, límites y versiones. | `grep` de contenidos. | — | [x] |
| T-09 | Arranque y CA-01/02/03. | `ps`, `port`, `curl`. | CA-01, CA-02, CA-03 | [x] |
| T-10 | Persistencia y reinicio. | Editar/restaurar, `stop`/`start`, `curl`. | CA-04, CA-05 | [x] |
| T-11 | Páginas de error. | `curl` 404/500. | CA-06, CA-07 | [x] |
| T-12 | Rotación y registro. | `logrotate -f`, `ls`, patrón, cron. | CA-08, CA-11 | [x] |
| T-13 | Cambio de puerto. | `8081`, `up -d`, `curl`, restaurar `8080`. | CA-09 | [x] |
| T-14 | Límites de logs. | `inspect`, `docker compose logs`. | CA-10 | [x] |
| T-15 | Reporte final. | `z-report.md`. | — | [x] |

Cobertura: CA-01..CA-11. Evidencia detallada y limitaciones: `z-report.md`.
