# Constitución del proyecto

Principios innegociables del proyecto. Esta constitución tiene la máxima autoridad: ninguna spec, plan, task ni implementación puede contradecirla. Las decisiones técnicas específicas pertenecen a cada spec; las instrucciones operativas del agente, a `AGENTS.md`.

## Principios

**P1. Specs como fuente de verdad.** Todo cambio de comportamiento exige actualizar la spec antes del código. Ante divergencias, el agente informa el conflicto y propone la corrección; nunca modifica la spec para justificar código existente.

**P2. Reproducibilidad y configuración explícita.** El proyecto debe poder construirse y ejecutarse desde cero siguiendo la documentación, dentro de los entornos declarados como compatibles. Las versiones, dependencias y configuraciones relevantes deben declararse en los archivos correspondientes, sin pasos manuales ocultos ni valores implícitos que comprometan la reproducibilidad.

**P3. Secretos protegidos.** Nunca se exponen credenciales ni datos sensibles en el código, la documentación, los logs o las salidas del agente. Los ejemplos utilizan únicamente valores ficticios.

**P4. Alcance mínimo.** Cada task realiza únicamente los cambios necesarios y autorizados. Los cambios auxiliares se justifican; cualquier ampliación sustancial del alcance requiere aprobación previa del usuario.

**P5. Verificabilidad y trazabilidad.** Cada requisito debe vincularse con sus criterios de aceptación, tareas y pruebas. Una feature solo se declara terminada cuando cumple los criterios y se ejecutan las verificaciones aplicables. Todo fallo o aspecto no verificado se informa.

**P6. Operaciones seguras.** El agente solo modifica recursos dentro del alcance autorizado. No realiza operaciones destructivas o irreversibles ni altera recursos compartidos o globales sin autorización explícita.

**P7. Control de versiones humano.** El usuario es el único responsable de Git. El agente no ejecuta comandos de Git, ni siquiera de consulta, ni gestiona ramas, commits, merges, tags o sincronizaciones. Puede proponer comandos, pero nunca ejecutarlos.

**P8. Honestidad y ambigüedad.** El agente informa errores, limitaciones y workarounds sin inventar resultados. Ante ambigüedades que afecten requisitos, alcance, seguridad, datos o arquitectura, solicita aclaraciones. Las decisiones menores y reversibles deben ser conservadoras y documentadas.

**P9. Idioma.** El código, los nombres de variables, funciones, clases, módulos y demás identificadores se escriben en inglés. Los mensajes dirigidos al usuario y toda la documentación del proyecto se redactan en español.

## Gobernanza

- Esta constitución solo puede modificarse con aprobación explícita del usuario. El agente puede proponer cambios, pero nunca aplicarlos por iniciativa propia.
- Ante conflictos con un principio, el agente informa el problema y propone alternativas; nunca lo incumple en silencio.
- Cada enmienda aprobada se registra con fecha, motivo y descripción del cambio.

## Historial de enmiendas

- AAAA-MM-DD — Versión inicial de la constitución.