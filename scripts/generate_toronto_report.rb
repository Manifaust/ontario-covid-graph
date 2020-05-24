#!/usr/bin/env ruby

require 'date'
require 'json'

require_relative 'scrape_toronto_data'

tabula_path = ARGV[0]
raw_reports_dir = ARGV[1]
output_report_path = ARGV[2]

def derive_new_cases(total_cases)
  total_cases = total_cases.sort.to_h

  last_total_cases = nil
  total_cases.each do |date, val_map|
    total_cases = val_map[:'cities_total_cases_from_epidemiologic_summary'][:'Toronto Public Health']
    new_cases = nil

    unless last_total_cases.nil?
      new_cases = total_cases - last_total_cases
      val_map[:'cities_new_cases_from_epidemiologic_summary'] = {
        'Toronto Public Health': new_cases
      }
    end

    puts "Toronto cases: #{total_cases}, new cases: #{new_cases}"
    last_total_cases = total_cases
  end
end

raw_reports_glob = File.join(raw_reports_dir, 'moh-covid-19-report-en-*.pdf')
epidemiologic_report_paths = Dir.glob(raw_reports_glob).sort

scrape_toronto_data = ScrapeTorontoData.new(tabula_path)

date_toronto_map = {}

epidemiologic_report_paths.each do |pdf_path|
  pdf_basename = File.basename(pdf_path)

  date_regex = /moh-covid-19-report-en-(?<date>\d{4}-\d{2}-\d{2})\.pdf/
  matches = date_regex.match(pdf_basename)

  date = Date.parse(matches[:date])

  puts "Scraping #{pdf_basename}..."

  data = scrape_toronto_data.scrape(pdf_path)
  date_toronto_map[date.to_s] = data unless data.empty?
end

derive_new_cases(date_toronto_map)

File.write(
  output_report_path,
  JSON.pretty_generate(date_toronto_map.sort.to_h)
)
puts "Wrote city cases from epidemiologic summaries report: #{output_report_path}"
