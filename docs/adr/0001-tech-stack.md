# ADR-0001: Stack técnico del proyecto

- **Estado:** Accepted
- **Fecha:** 2026-11-05
- **Decisores:** Esteban Alonzo

## Contexto
Proyecto 1 de portafolio: API RAG para consultar normativas TI. Restricciones de entorno: 4 vCPU / 7 GB RAM host, WSL2 limitado a ~3 GB, sin presupuesto, Docker Engine en WSL2. Debe parecer un repo de producción.

## Decisión

| Área | Decisión | Justificación |
|------|----------|---------------|
| Lenguaje | **Python 3.11** (fijado `>=3.11,<3.12`) | Estabilidad de wheels para todo el stack (FastAPI, sentence-transformers, faiss-cpu). Python 3.12+ presenta problemas con wheels binarias en Linux. |
| Gestor de paquetes | **uv** + `uv.lock` | 10–100x más rápido que pip; lockfile reproducible; gestiona la versión de Python por proyecto. |
| Framework API | **FastAPI** | Estándar de facto, tipado, OpenAPI nativo, async. |
| Vector store | **FAISS CPU** | Maduro, probado, persistencia trivial, wheels disponibles en Linux CPU. Descartado `sqlite-vec` por menor madurez. |
| Embeddings | **sentence-transformers/all-MiniLM-L6-v2** | ~90 MB, corre en CPU, excelente calidad/velocidad para RAG. |
| Abstracción LLM | `LLM_PROVIDER = mock \| ollama \| gemini` | Default `mock` sin API key; garantiza tests y CI sin dependencias externas. |
| CI | **GitHub Actions** | Estándar, gratuito para repos públicos. |

## Alternativas consideradas
- **Python 3.12/3.14** — descartado por incompatibilidad con PyTorch y wheels binarias.
- **pip + pip-tools** — descartado por velocidad y ergonomía frente a `uv`.
- **Chroma / Qdrant / pgvector** — descartado por restricción explícita (RAM y complejidad operativa).
- **sqlite-vec** — descartado por menor madurez y menos material de referencia.

## Consecuencias
- **Positivas:** stack conocido, reproducible, CI rápido, imagen Docker pequeña.
- **Trade-offs:** si en el futuro se necesita ANN aproximado a gran escala, evaluar migrar de `IndexFlatIP` a `IndexIVFFlat`.
