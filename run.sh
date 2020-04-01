#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

tabula="$DIR/third_party/tabula/tabula-1.0.3-jar-with-dependencies.jar"

scripts/generate_intermediate_reports.sh \
  "$tabula" \
  "$DIR/raw_reports" \
  "$DIR/intermediate_reports"

scripts/generate_final_report.rb \
  "$DIR/intermediate_reports"

