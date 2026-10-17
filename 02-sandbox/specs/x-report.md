## Reporte al terminar
Al completar todas las tasks de una feature, escribe el reporte en
`specs/features/NNN-nombre/z-report.md` (NNN-nombre es el directorio
de la feature actual).

Reglas del formato:
- Solo viñetas de una línea, sin párrafos ni explicaciones largas.
- Máximo 5 viñetas por sección. Si una sección no aplica, escribe `- Ninguno`.
- Solo hechos: sin opiniones, sin justificaciones, sin relleno.
- No repitas contenido de `spec.md`, `plan.md` o `tasks.md`.
- Sé honesto: si algo falló, se hizo un workaround o no se pudo
  verificar, debe aparecer aquí.

Plantilla:

    # Reporte NNN-nombre

    ## Hecho
    - ...

    ## Verificado
    - ... (comando o criterio -> resultado)

    ## No verificado
    - ...

    ## Problemas y errores
    - ... (error -> causa -> solución)

    ## Divergencias spec/código
    - ...