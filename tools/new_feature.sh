#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

dart run "$PROJECT_ROOT/tools/create_feature.dart" "$1" "$2"

# Usage:
# dart run tools/create_feature.dart host lib/features   