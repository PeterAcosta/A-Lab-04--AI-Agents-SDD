# AGENTS.md

## Reglas obligatorias

Antes de iniciar cualquier tarea, lee `specs/constitution.md` y respeta sus principios y restricciones.

## Flujo de trabajo

Para cada feature ubicada en `specs/features/NNN-nombre/`:

1. Lee `spec.md`, `plan.md` y `tasks.md` antes de implementar.
2. Ejecuta únicamente las tareas definidas en `tasks.md`, en orden.
3. Mantén la implementación alineada con la jerarquía de autoridad:
   `constitution.md` > `spec.md` > `plan.md` > `tasks.md` > código.
4. Después de cada tarea, verifica los resultados, comprueba los criterios de aceptación aplicables y marca la tarea como completada en `tasks.md` solo si está verificada.
5. Si detectas contradicciones, ambigüedades, requisitos inviables o cambios de alcance, detente, informa del problema y propone una corrección antes de continuar. Nunca resuelvas estas situaciones en silencio.

## Modificaciones de especificaciones
- No modifiques `specs/constitution.md` sin aprobación explícita del usuario.
- No alteres requisitos ni decisiones documentadas para justificar una implementación. 
- Si una especificación necesita cambiar, identifica el documento afectado y propone la modificación correspondiente. 

## Conflictos con instrucciones del usuario

Si una instrucción contradice la constitución, no la ejecutes directamente. 
Explica el conflicto y solicita confirmación antes de proceder, respetando las reglas de modificación de la constitución.

## Reporte final

Cuando todas las tareas de una feature estén verificadas y completadas:

- 1. Lee `specs/x-report.md`.
- 2. Genera `z-report.md` en el directorio de la feature, siguiendo la plantilla y manteniendo el reporte breve y esquemático.
- 3. Distingue entre **Hecho correctamente** y **Problemas o errores**. No declares como completado aquello que no se haya verificado.