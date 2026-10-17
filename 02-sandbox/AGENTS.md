# AGENTS.md

## Reglas obligatorias
Antes de cualquier tarea, lee `specs/constitution.md`.
Solo se modifica con aprobación explícita del usuario: nunca la
edites por iniciativa propia.

## Flujo de trabajo
1. Lee `specs/constitution.md`.
2. Lee `spec.md`, `plan.md` y `tasks.md` de la feature en
   `specs/features/NNN-nombre/`.
3. Implementa solo lo que describen las tasks, en orden.
4. Si el código y la spec divergen, no lo resuelvas en silencio:
   detente, explica la divergencia y propón el cambio en el nivel
   que corresponda (ver "Jerarquía de autoridad").
5. Al terminar cada task, márcala como completada en `tasks.md` y
   verifica los criterios de aceptación de `spec.md`.

## Jerarquía de autoridad
`constitution.md` > `spec.md` > `plan.md` > `tasks.md` > código.
Si dos niveles chocan, prevalece el de mayor autoridad, pero no
resuelvas el choque en silencio: repórtalo y propón corregir el
nivel inferior. Si el error está en la spec (por ejemplo, resulta
inviable al implementar), propón enmendarla en vez de forzar el
código.

## Conflictos con el usuario
Si una instrucción del usuario va contra la constitución, avisa
antes de ejecutar y pide confirmación.

## Reporte al terminar
Al completar todas las tasks de una feature, lee
`specs/x-report.md` y escribe el reporte en
`specs/features/NNN-nombre/z-report.md` siguiendo ese formato.

