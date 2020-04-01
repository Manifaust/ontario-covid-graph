#!/usr/bin/env bash

set -euo pipefail

tabula="$1"
raw_reports="$2"
intermediate_reports="$3"

java -jar "$tabula" \
  --batch "$raw_reports" \
  --pages 2 \
  --guess \
  --format JSON

mkdir -p "$intermediate_reports"

mv "$raw_reports"/*.json "$intermediate_reports"

