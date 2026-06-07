# Configuración de Entornos — Contactando

## Cómo funciona el flujo completo

```
.env.dev.json
      │
      │  --dart-define-from-file=.env.dev.json
      ▼
Flutter inyecta cada key como dart-define
      │
      ▼
String.fromEnvironment('SUPABASE_URL')   ← AppConstants
      │
      ▼
AppConstants.validate()                  ← bootstrap.dart
      │
      ▼
Supabase.initialize(url, anonKey)
```

## Setup inicial (una sola vez)

```bash
# 1. Copia el ejemplo y rellena con tus valores reales
cp .env.example.json .env.dev.json
cp .env.example.json .env.prod.json

# 2. Instala dependencias
make get

# 3. Genera código (injectable, json_serializable, etc.)
make gen
```

## Comandos del día a día

| Comando             | Acción                              |
|---------------------|-------------------------------------|
| `make run-dev`      | Correr en dispositivo/emulador DEV  |
| `make run-dev-web`  | Correr en Chrome (DEV)              |
| `make build-apk`    | Build APK release (PROD)            |
| `make build-aab`    | Build AppBundle Play Store (PROD)   |
| `make build-ipa`    | Build IPA App Store (PROD)          |
| `make gen`          | Generar código                      |
| `make test`         | Correr tests                        |
| `make lint`         | Analizar código                     |
| `make clean`        | Limpiar build                       |

## Seguridad

| Archivo              | ¿Va al repo? | Motivo                              |
|----------------------|:------------:|-------------------------------------|
| `.env.dev.json`      | ❌ NO        | Contiene claves reales              |
| `.env.prod.json`     | ❌ NO        | Contiene claves reales              |
| `.env.example.json`  | ✅ SÍ        | Solo tiene placeholders, es seguro  |
| `app_constants.dart` | ✅ SÍ        | No tiene ningún valor hardcodeado   |

## CI/CD (GitHub Actions, Codemagic, Bitrise)

En tu pipeline, pasa las variables como secrets del entorno:

```yaml
# GitHub Actions (ejemplo)
- name: Build
  run: |
    echo '${{ secrets.ENV_PROD_JSON }}' > .env.prod.json
    make build-aab
```

Guarda el contenido completo del `.env.prod.json` como un secret llamado
`ENV_PROD_JSON` en tu proveedor de CI. Nunca hardcodees las claves en el YAML.

## ¿Por qué NO usar assets para cargar el JSON en runtime?

Cargar el JSON como asset lo empaqueta dentro del APK/IPA y cualquiera puede
extraerlo con `apktool` o `unzip`. Con `--dart-define-from-file` los valores
se compilan dentro del binario Dart (no en texto plano) y desaparecen como
strings directamente accesibles. Es mucho más difícil extraerlos.
