#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

gem install bundler
bundle install --jobs 4 --retry 3

status_report_page_url='https://data.ontario.ca/dataset/status-of-covid-19-cases-in-ontario'
status_report_csv_name='covidtesting.csv'
status_report_destination="$DIR"/raw_reports/status-of-covid-19-cases-in-ontario.csv
confirmed_cases_report_page_url='https://data.ontario.ca/dataset/confirmed-positive-cases-of-covid-19-in-ontario'
confirmed_cases_report_csv_name='conposcovidloc.csv'
confirmed_cases_report_destination="$DIR"/raw_reports/confirmed-positive-cases-of-covid-19-cases-in-ontario.csv

function download_csv {
  csv_url="$(scripts/fetch_status_report_url.rb $1 $2)"
  echo "CSV URL: $csv_url"
  status_csv_path=$3
  curl "$csv_url" --output "$status_csv_path"
  echo "Downloaded to: $status_csv_path"
}

echo 'Fetching CSV URL for: Status of COVID-19 cases in Ontario'
download_csv "$status_report_page_url" "$status_report_csv_name" "$status_report_destination"

echo 'Fetching CSV URL for: Confirmed Cases of COVID-19 cases in Ontario'
download_csv "$confirmed_cases_report_page_url" "$confirmed_cases_report_csv_name" "$confirmed_cases_report_destination"

scripts/generate_final_report.rb \
  "$status_report_destination" \
  "$DIR/report.json"

