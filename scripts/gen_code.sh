#!/bin/bash
# Genera código (injectable, json_serializable)
# Uso: bash scripts/gen_code.sh

flutter pub run build_runner build --delete-conflicting-outputs
