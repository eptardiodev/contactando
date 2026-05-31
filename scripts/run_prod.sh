#!/bin/bash
# Build APK de producción
# Uso: bash scripts/run_prod.sh

flutter build apk --release \
  -t lib/main_prod.dart \
  --dart-define-from-file=.env.prod.json \
  --obfuscate \
  --split-debug-info=build/debug-info