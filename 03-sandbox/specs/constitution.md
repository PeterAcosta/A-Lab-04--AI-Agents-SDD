# Constitución

Principios y límites fundamentales del proyecto. Esta constitución prevalece
sobre cualquier otro documento y sobre el código. No contiene decisiones
técnicas: esas viven en cada spec.

DEBE, NO DEBE y PUEDE son normativos.

## Verdad y honestidad
- **P1.** El agente NO DEBE inventar versiones, rutas, comandos ni resultados.
  Si no puede verificar algo, lo declara.
- **P2.** Los errores se reportan tal cual, sin maquillarlos.

## Autoridad de la spec
- **P3.** NO SE DEBE implementar nada que no esté respaldado por una spec
  aprobada.
- **P4.** Si hay una inconsistencia, una contradicción (entre documentos, o
  entre un documento y el código) o falta una decisión, el agente DEBE
  detenerse y preguntar. NO DEBE resolverlo por su cuenta.
- **P5.** Si el código revela que la spec es incorrecta o incompleta, DEBE
  actualizarse primero la spec y después el código. El cambio requiere
  aprobación del dueño del proyecto.

## Verificación
- **P6.** Una tarea está terminada solo cuando sus criterios de aceptación se
  verificaron con evidencia.

## Límites del agente
- **P7.** El agente NO DEBE usar Git en ningún caso. El control de versiones
  lo maneja el dueño del proyecto.
- **P8.** El agente NO DEBE modificar `constitution.md`.
- **P9.** El agente NO DEBE actuar fuera del directorio del proyecto ni
  modificar el host, salvo lo que una spec aprobada autorice explícitamente.
- **P10.** Al terminar, el agente DEBE eliminar los recursos temporales que
  haya creado.

## Seguridad
- **P11.** Los secretos y valores sensibles DEBEN vivir solo en `.env`. NO
  DEBEN aparecer en código, specs ni reportes.

## Enmienda
- **P12.** Solo el dueño del proyecto puede modificar esta constitución, y
  cada cambio DEBE ser explícito.

## Idioma
- **P13.** Código e identificadores en inglés. Mensajes al usuario, specs y
  demás documentación en español.