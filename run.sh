#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

gem install bundler
bundle install --jobs 4 --retry 3

status_report_page_url='https://data.ontario.ca/dataset/status-of-covid-19-cases-in-ontario'
status_report_csv_name='covidtesting.csv'
raw_reports_dir="$DIR"/raw_reports
status_report_destination="$raw_reports_dir"/status-of-covid-19-cases-in-ontario.csv
confirmed_cases_report_page_url='https://data.ontario.ca/dataset/confirmed-positive-cases-of-covid-19-in-ontario'
confirmed_cases_report_csv_name='conposcovidloc.csv'
confirmed_cases_report_destination="$raw_reports_dir"/confirmed-positive-cases-of-covid-19-cases-in-ontario.csv

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

echo 'Fetching epidemiologic reports'
scripts/download_epidemiologic_pdfs.rb "$raw_reports_dir"

intermediate_reports_dir="$DIR"/intermediate_reports
mkdir -p "$intermediate_reports_dir"
cities_report_path="$intermediate_reports_dir"/cities.json
institutions_report_path="$intermediate_reports_dir"/institutions.json

echo 'Generating intermediate cities report'
scripts/generate_cities_report.rb \
  "$confirmed_cases_report_destination" \
  "$cities_report_path"

echo 'Generating intermediate institutions report'
scripts/generate_institutions_report.rb \
  'third_party/tabula/tabula-1.0.3-jar-with-dependencies.jar' \
  "$raw_reports_dir" \
  "$raw_reports_dir"/old_institutions_data.json \
  "$institutions_report_path"

echo 'Generating final report'
scripts/generate_final_report.rb \
  "$status_report_destination" \
  "$cities_report_path" \
  "$institutions_report_path" \
  "$DIR/report.json"

