#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

gem install bundler
bundle install --jobs 4 --retry 3

raw_reports_dir="$DIR"/raw_reports

status_report_page_url='https://data.ontario.ca/dataset/status-of-covid-19-cases-in-ontario'
status_report_csv_name='covidtesting.csv'
status_report_csv_save_path="$raw_reports_dir"/status-of-covid-19-cases-in-ontario.csv
daily_change_phu_report_page_url='https://data.ontario.ca/dataset/status-of-covid-19-cases-in-ontario'
daily_change_phu_report_csv_name='daily_change_in_cases_by_phu.csv'
daily_change_phu_report_csv_save_path="$raw_reports_dir"/daily-change-phu.csv

function download_csv {
  csv_url="$(scripts/fetch_status_report_url.rb $1 $2)"
  echo "CSV URL: $csv_url"
  status_csv_path=$3
  curl "$csv_url" --output "$status_csv_path"
  echo "Downloaded to: $status_csv_path"
}

echo 'Fetching CSV URL for: Status of COVID-19 cases in Ontario'
download_csv "$status_report_page_url" "$status_report_csv_name" "$status_report_csv_save_path"

echo 'Fetching CSV URL for: Status of COVID-19 by Public Health Unit'
download_csv "$daily_change_phu_report_page_url" "$daily_change_phu_report_csv_name" "$daily_change_phu_report_csv_save_path"

echo 'Fetching epidemiologic reports'
scripts/download_epidemiologic_pdfs.rb "$raw_reports_dir"

intermediate_reports_dir="$DIR"/intermediate_reports
mkdir -p "$intermediate_reports_dir"
statuses_report_path="$intermediate_reports_dir"/statuses.json
institutions_report_path="$intermediate_reports_dir"/institutions.json
toronto_report_path="$intermediate_reports_dir"/toronto_statuses.json

set -x
echo 'Generating statuses report from status CSV'
scripts/generate_statuses_report.rb \
  "$status_report_csv_save_path" \
  "$statuses_report_path"

echo 'Generating institutions report'
scripts/generate_institutions_report.rb \
  'third_party/tabula/tabula-1.0.3-jar-with-dependencies.jar' \
  "$raw_reports_dir" \
  "$institutions_report_path" \
  "$institutions_report_path"

echo 'Generating Toronto cases report'
scripts/generate_toronto_cases_report.rb \
  "$daily_change_phu_report_csv_save_path" \
  "$toronto_report_path"

echo 'Generating final report'
scripts/generate_final_report.rb \
  "$statuses_report_path" \
  "$institutions_report_path" \
  "$toronto_report_path" \
  "$DIR/report.json"

set +x

