# ADR-0002: Manejo de zonas horarias

- **Estado:** Accepted
- **Fecha:** 2026-11-05
- **Decisores:** Esteban Alonzo

## Contexto
Un backend no puede inferir de forma fiable la zona horaria del cliente. Intuición inicial del autor: "que se adapte automáticamente al usuario".

## Decisión
- **Almacenar y loggear siempre en UTC** (ISO-8601 con sufijo `Z`).
- **El cliente es responsable** de convertir para presentación.
- Si un endpoint necesita presentar datos en la zona del usuario, se acepta un parámetro opcional `timezone` (IANA, ej. `America/Santiago`) y se convierte explícitamente con `zoneinfo`.
- Nunca se "auto-detecta" la zona horaria en el servidor.

## Alternativas consideradas
- **Auto-detectar vía header `Time-Zone` del cliente** — descartado: no todos los clientes lo envían, no está estandarizado.
- **Detectar por IP** — descartado por privacidad, inexactitud y dependencia externa.

## Consecuencias
- **Positivas:** compatibilidad total con logs y bases de datos estándar; respuestas deterministas.
- **Trade-offs:** el frontend debe gestionar la conversión. Documentado en el contrato de la API.
