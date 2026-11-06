.PHONY: help install lint format test test-cov run clean

help:
	@echo "Available targets:"
	@echo "  install    Install dependencies (uv sync)"
	@echo "  lint       Run ruff check"
	@echo "  format     Run ruff format"
	@echo "  test       Run pytest"
	@echo "  test-cov   Run pytest with coverage"
	@echo "  run        Run the API locally"
	@echo "  clean      Remove caches and build artifacts"

install:
	uv sync

lint:
	uv run ruff check .

format:
	uv run ruff format .

test:
	uv run pytest

test-cov:
	uv run pytest --cov=app --cov-report=term-missing --cov-report=html

run:
	uv run uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

clean:
	rm -rf .pytest_cache .ruff_cache .coverage htmlcov build dist
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
