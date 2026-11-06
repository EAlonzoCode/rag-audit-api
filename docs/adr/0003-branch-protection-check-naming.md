# ADR-0003: Nombres de status checks en protección de rama

- **Estado:** Accepted
- **Fecha:** 2026-11-06
- **Decisores:** Esteban Alonzo

## Contexto
GitHub Actions expone dos nombres por cada job: el nombre del workflow (`name:` de nivel superior) y el nombre del job (`jobs.<id>.name`). En la UI del PR, el check aparece como `Workflow / Job`, pero el **nombre real del check run** que emite GitHub Actions es solo el `jobs.<id>.name`. La protección de rama (`required_status_checks.contexts`) hace match **literal** contra ese nombre real, no contra el formato `Workflow / Job` visible en la UI.

Durante el Hito 0 la protección de `main` exigía `CI/lint-and-test` (formato visible), pero el job solo emitía `lint-and-test` (nombre real), lo que habría bloqueado todos los PRs futuros.

## Decisión
- Alinear el nombre real del check con el `contexts` de la protección: el job se renombra a `CI/lint-and-test` para que el check run emitido coincida con lo exigido.
- Mantener el `name:` del workflow como `CI`, aceptando la redundancia visual `CI / CI/lint-and-test` en la UI, a cambio de no tocar la protección ni depender de convenciones frágiles.
- **Regla operativa permanente:** cualquier check nuevo que agreguemos a `required_status_checks` debe usar exactamente `jobs.<id>.name`, nunca el formato `Workflow / Job`.

## Alternativas consideradas
- **Cambiar la protección a `lint-and-test` (nombre del job)** — descartado por el riesgo de re-desalineación cada vez que se renombre el workflow.
- **Eliminar la protección temporalmente durante el fix** — descartado porque pierde la red de seguridad.
- **Usar `pull_request_target` en lugar de `pull_request`** — descartado por implicaciones de seguridad (corre con permisos del repo base y secretos expuestos).

## Consecuencias
- **Positivas:** check requerido = check emitido; protección funcional; regla documentada para futuros checks.
- **Trade-offs:** nombre visible redundante (`CI / CI/lint-and-test`). Cosmético, aceptado.
