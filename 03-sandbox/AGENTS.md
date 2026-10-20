# AGENTS.md

## Primero

Antes de hacer cualquier cosa, lee `specs/constitution.md`. Sus reglas
son obligatorias y no se repiten aquí.

## Orden de autoridad

`constitution.md` > `spec.md` > `plan.md` > `tasks.md` > código.

Ante un conflicto o inconsistencia: detente y avisa.

## Estructura del proyecto

    .
    ├── AGENTS.md
    ├── .env
    └── specs/
        ├── constitution.md
        └── features/
            └── NNN-nombre/
                ├── spec.md
                ├── plan.md
                ├── tasks.md
                └── z-report.md
			

## Flujo de trabajo

Para cada feature, en este orden:

1. **spec.md**: qué se quiere y criterios de aceptación.
2. **plan.md**: cómo se hará. Aquí van las decisiones técnicas.
3. **tasks.md**: tareas pequeñas y verificables derivadas del plan.
4. **Implementación**: ejecuta las tareas en orden.


## Reporte final

Al terminar cada feature, escribe `specs/features/NNN-nombre/z-report.md`:

- Punto por punto, esquemático y mínimo.
- Dos secciones: **Hecho correctamente** y **Problemas o errores**.
- Es un registro, no una explicación extensa.