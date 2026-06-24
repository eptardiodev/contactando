// lib/main.dart
// Entry point por defecto → apunta a DEV.
// Para producción usa: flutter run -t lib/main_prod.dart

import 'bootstrap.dart';
import 'core/constants/app_constants.dart';

void main() => bootstrap(Flavor.dev);