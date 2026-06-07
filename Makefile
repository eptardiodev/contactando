# ─────────────────────────────────────────────────────────────────────────────
# Contactando — Makefile
# Uso: make <comando>
# ─────────────────────────────────────────────────────────────────────────────

# Archivos de entorno
ENV_DEV  := .env.dev.json
ENV_PROD := .env.prod.json

# Targets de entrada
TARGET_DEV  := lib/main_dev.dart
TARGET_PROD := lib/main_prod.dart

# ─── Desarrollo ──────────────────────────────────────────────────────────────

.PHONY: run-dev
run-dev: check-env-dev ## Corre la app en modo DEV
	flutter run \
		--target $(TARGET_DEV) \
		--dart-define-from-file=$(ENV_DEV)

.PHONY: run-dev-web
run-dev-web: check-env-dev ## Corre la app en Chrome (DEV)
	flutter run \
		--target $(TARGET_DEV) \
		--dart-define-from-file=$(ENV_DEV) \
		-d chrome

# ─── Build Android ───────────────────────────────────────────────────────────

.PHONY: build-apk
build-apk: check-env-prod ## Build APK de release (PROD)
	flutter build apk \
		--target $(TARGET_PROD) \
		--dart-define-from-file=$(ENV_PROD) \
		--release

.PHONY: build-aab
build-aab: check-env-prod ## Build AppBundle para Play Store (PROD)
	flutter build appbundle \
		--target $(TARGET_PROD) \
		--dart-define-from-file=$(ENV_PROD) \
		--release

# ─── Build iOS ───────────────────────────────────────────────────────────────

.PHONY: build-ipa
build-ipa: check-env-prod ## Build IPA para App Store (PROD)
	flutter build ipa \
		--target $(TARGET_PROD) \
		--dart-define-from-file=$(ENV_PROD) \
		--release

# ─── Codegen ─────────────────────────────────────────────────────────────────

.PHONY: gen
gen: ## Genera código (injectable, json_serializable, l10n)
	dart run build_runner build --delete-conflicting-outputs

.PHONY: gen-watch
gen-watch: ## Genera código en modo watch
	dart run build_runner watch --delete-conflicting-outputs

# ─── Tests ───────────────────────────────────────────────────────────────────

.PHONY: test
test: check-env-dev ## Corre todos los tests unitarios
	flutter test \
		--dart-define-from-file=$(ENV_DEV)

.PHONY: test-coverage
test-coverage: check-env-dev ## Tests con cobertura
	flutter test \
		--dart-define-from-file=$(ENV_DEV) \
		--coverage
	genhtml coverage/lcov.info -o coverage/html

# ─── Calidad ─────────────────────────────────────────────────────────────────

.PHONY: lint
lint: ## Analiza el código con flutter analyze
	flutter analyze

.PHONY: format
format: ## Formatea el código
	dart format lib test --line-length 100

# ─── Utilidades ──────────────────────────────────────────────────────────────

.PHONY: clean
clean: ## Limpia artefactos de build
	flutter clean

.PHONY: get
get: ## flutter pub get
	flutter pub get

# ─── Guardianes de entorno ───────────────────────────────────────────────────

.PHONY: check-env-dev
check-env-dev:
	@test -f $(ENV_DEV) || ( \
		echo ""; \
		echo "  ERROR: No se encontró $(ENV_DEV)"; \
		echo "  Copia .env.example.json → .env.dev.json y rellena los valores."; \
		echo ""; \
		exit 1 \
	)

.PHONY: check-env-prod
check-env-prod:
	@test -f $(ENV_PROD) || ( \
		echo ""; \
		echo "  ERROR: No se encontró $(ENV_PROD)"; \
		echo "  Copia .env.example.json → .env.prod.json y rellena los valores."; \
		echo ""; \
		exit 1 \
	)

# ─── Ayuda ───────────────────────────────────────────────────────────────────

.PHONY: help
help: ## Muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
