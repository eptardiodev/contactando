import 'bootstrap.dart';
import 'core/constants/app_constants.dart';

/// Entry point DEV
///
/// Correr con:
///   flutter run --target lib/main_dev.dart --dart-define-from-file=.env.dev.json
///
/// O simplemente:
///   make run-dev
void main() => bootstrap(Flavor.dev);
