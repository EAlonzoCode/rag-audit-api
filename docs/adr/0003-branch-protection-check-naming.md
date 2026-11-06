# ADR-0003: Nombres de status checks en protección de rama

- **Estado:** Accepted
- **Fecha:** 2026-11-06
- **Decisores:** Esteban Alonzo

## Contexto
GitHub Actions expone dos nombres por cada job: el nombre del workflow (`name:` de nivel superior) y el nombre del job (`jobs.<id>.name`). En la UI del PR y en `gh pr checks` el check aparece como `Workflow / Job`, pero el **nombre real del check run** que emite GitHub Actions —y que la protección de rama compara literalmente— es solo el `jobs.<id>.name` cuando está definido, o el id del job si no lo está.

Durante el Hito 0 la protección de `main` exigía `CI/lint-and-test` (formato de UI), pero el job emitía `lint-and-test` (nombre real). Eso habría bloqueado todos los PRs futuros.

## Decisión
- **No** añadir un `name:` custom al job. El check run se emite como `lint-and-test` (id del job).
- Configurar `required_status_checks.contexts = ["lint-and-test"]` en la protección de `main`.
- **Regla operativa permanente:** `required_status_checks.contexts` debe contener exactamente el `jobs.<id>.name` (o el `id` si no hay `name:`), nunca el formato `Workflow / Job` visible en la UI.

## Alternativas consideradas
- **Renombrar el job a `CI/lint-and-test`** — descartado por la redundancia visual `CI / CI/lint-and-test` en la UI.
- **Usar `pull_request_target`** — descartado por implicaciones de seguridad (corre con permisos del repo base).
- **Desactivar la protección durante el fix** — descartado por perder la red de seguridad.

## Consecuencias
- **Positivas:** check requerido = check emitido; UI limpia (`CI / lint-and-test`); regla documentada para futuros checks.
- **Trade-offs:** si se renombra el workflow, el check se sigue emitiendo igual (el id del job no cambia). Si se renombra el job, hay que actualizar la protección en el mismo PR.
