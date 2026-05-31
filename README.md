# contactando

CRM ligero para gestión de clientes. Flutter + Supabase.

## Stack

| Capa | Paquete |
|---|---|
| State | flutter_bloc 8+ |
| Routing | go_router (StatefulShellRoute) |
| DI | get_it + injectable |
| Backend | supabase_flutter |
| Errores | fpdart (Either) |
| i18n | intl + flutter_localizations |
| Tests | bloc_test + mocktail |

## Estructura

```
lib/
├── core/
│   ├── constants/        # AppConstants (dart-define)
│   ├── di/               # get_it + injectable
│   ├── errors/           # Failures + Exceptions
│   ├── router/           # GoRouter + auth guard
│   ├── shell/            # AppShell (tabs) + AppDrawer
│   └── theme/            # AppTheme, colors, typography
├── features/
│   ├── auth/             # Login, register, forgot password
│   ├── dashboard/        # Tab 1
│   ├── contacts/         # Tab 2
│   ├── transactions/     # Tab 3
│   ├── settings/         # Tab 4
│   └── profile/          # Acceso desde AppBar
├── l10n/                 # ARB files (es, en)
├── app.dart
├── bootstrap.dart
├── main_dev.dart
└── main_prod.dart
```

## Configuración inicial

### 1. Copia tus .env

```bash
cp .env.dev.example .env.dev
cp .env.prod.example .env.prod
# Edita los archivos con tus URLs de Supabase
```

### 2. Instala dependencias

```bash
fvm use          # o flutter pub get
flutter pub get
```

### 3. Genera código

```bash
bash scripts/gen_code.sh
```

### 4. Corre en DEV

```bash
bash scripts/run_dev.sh
```

### 5. Build PROD

```bash
bash scripts/run_prod.sh
```

## Flavors

El flavor se controla vía `--dart-define=FLAVOR=dev|prod`.  
No se usan flavors nativos de Android/iOS para simplificar el setup inicial.  
Si necesitas íconos de app distintos por flavor, agrega `flutter_launcher_icons`.

## Auth guard

GoRouter redirige automáticamente:
- Sin sesión → `/login`
- Con sesión en rutas de auth → `/dashboard`

El guard se refresca automáticamente cuando Supabase emite un cambio de sesión.

## Agregar un nuevo feature

1. Crea la carpeta `lib/features/mi_feature/`
2. Estructura: `data/`, `domain/`, `presentation/`
3. Registra el repositorio en `core/di/`
4. Agrega la ruta en `core/router/app_router.dart`

## Tests

```bash
flutter test                    # unit + widget tests
flutter test integration_test/ # integration tests
```
