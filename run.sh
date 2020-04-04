#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


echo 'Fetching CSV URL for: Status of COVID-19 cases in Ontario'
csv_url="$(scripts/fetch_status_report_url.rb)"
echo "Status CSV URL: $csv_url"
status_csv_path="$DIR"/raw_reports/status-of-covid-19-cases-in-ontario.csv
curl "$csv_url" \
  --output "$status_csv_path"
echo "Downloaded to: $status_csv_path"

scripts/generate_final_report.rb \
  "$status_csv_path" \
  "$DIR/report.json"

