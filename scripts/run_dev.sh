#!/bin/bash
# Corre la app en modo DEV
# Uso: bash scripts/run_dev.sh

flutter run \
  -t lib/main_dev.dart \
  -d RZ8W90BXSZK \
  --dart-define-from-file=.env.dev.json