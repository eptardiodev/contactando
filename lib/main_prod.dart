import 'bootstrap.dart';

/// Entry point PROD
///
/// Build APK:
///   flutter build apk --target lib/main_prod.dart --dart-define-from-file=.env.prod.json
///
/// Build AppBundle:
///   flutter build appbundle --target lib/main_prod.dart --dart-define-from-file=.env.prod.json
///
/// Build iOS:
///   flutter build ipa --target lib/main_prod.dart --dart-define-from-file=.env.prod.json
///
/// O simplemente:
///   make build-apk | make build-aab | make build-ipa
void main() => bootstrap();
