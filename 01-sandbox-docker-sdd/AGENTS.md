# AGENTS.md

## Proyecto
Sandbox para correr nginx en Docker, construido con **spec-driven development, variante spec-anchored**.

## Qué significa spec-anchored aquí
Las specs no se escriben una vez y se olvidan: viven junto al código durante toda la vida del proyecto.
El flujo va en **ambos sentidos**:
- **Spec → código**: la spec define qué se construye.
- **Código → spec**: lo que se aprende al implementar vuelve a la spec, de forma explícita y registrada.

Spec y código nunca deben quedar divergentes en silencio.

## Orden de lectura obligatorio
Al iniciar cada sesión, y antes de cualquier cambio a spec, plan o código:
1. `specs/constitution.md` — **la ley del proyecto. Se lee primero y siempre.**
2. `specs/001-nginx/spec.md`
3. `specs/001-nginx/plan.md`
4. `specs/001-nginx/tasks.md`

## Jerarquía de autoridad
`constitution.md` > `spec.md` > `plan.md` > `tasks.md` > código.
Si dos niveles chocan, gana el de mayor autoridad.

## Invariantes (no cambian sin aprobación explícita del usuario)
- La constitución.
- La imagen base: exactamente `nginx:1.31.7-alpine3.24`. No `latest`, no otra versión, no otra variante, no parametrizarla.
- Los requisitos (RF) y criterios de aceptación (CA) de `spec.md`.

## Flujo normal (spec → código)
1. Toma la siguiente tarea sin marcar de `tasks.md`.
2. Implementa solo lo que esa tarea y el plan indican.
3. Ejecuta su verificación y el **gate constitucional** (ver `tasks.md`).
4. Marca `[x]` y pasa a la siguiente. Si la verificación falla, no avances.

## Flujo inverso (código → spec): protocolo de cambio
Si al implementar descubres que algo de la spec, el plan o las tareas es incorrecto, incompleto o inviable:

1. **DETENTE.** No improvises ni "arregles" solo el código.
2. **Clasifica** el hallazgo:
   - **A. Detalle**: no cambia requisitos ni criterios (ej. un flag, un nombre de archivo). Actualiza `plan.md` y/o `tasks.md` y regístralo en "Hallazgos" de `tasks.md`.
   - **B. Cambio de requisito o criterio**: afecta `spec.md`. Propón el cambio al usuario (qué cambia y por qué) y **espera aprobación** antes de aplicarlo. Al aprobarse, edita `spec.md`, añade una fila al "Registro de cambios" y revisa qué partes de `plan.md` y `tasks.md` quedan afectadas.
   - **C. Choca con la constitución**: está prohibido. Explica el conflicto al usuario. Solo el usuario puede enmendar la constitución.
3. **Sincroniza**: tras cualquier cambio, spec, plan, tareas y código deben describir lo mismo.
4. Si cambias código por cualquier motivo, comprueba que la spec lo sigue describiendo con exactitud.

## Reglas
- **Sin cambios silenciosos**: todo cambio en spec o código se refleja en el otro en el mismo conjunto de cambios.
- Ante ambigüedad o imposibilidad, pregunta. No inventes.
- No agregues archivos, servicios ni dependencias fuera de los listados en `plan.md`.
- Usa los IDs estables (RF, CA, D, T) al hablar de cambios y en mensajes de commit. Ejemplo: `T6: levantar entorno (CA1, CA2)`.
- Si una verificación falla por un problema externo (red, registro), reporta el error tal cual. No cambies la spec para esquivarlo.

## Comandos útiles
- Levantar: `docker compose up -d --build`
- Logs: `docker compose logs -f nginx`
- Bajar: `docker compose down`