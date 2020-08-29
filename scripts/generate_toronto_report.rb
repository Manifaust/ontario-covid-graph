#!/usr/bin/env ruby

require 'date'
require 'json'

require_relative 'scrape_toronto_data'

tabula_path = ARGV[0]
raw_reports_dir = ARGV[1]
old_toronto_data_path = ARGV[2]
output_report_path = ARGV[3]

def day_before?(date, possible_date_before)
  return false if date.nil? || possible_date_before.nil?
  (date - 1).to_s == possible_date_before.to_s
end

def derive_new_cases(total_cases)
  total_cases = total_cases.sort.to_h

  last_total_cases = nil
  last_date = nil
  total_cases.each do |date_string, val_map|
    total_cases = val_map['cities_total_cases_from_epidemiologic_summary']['Toronto Public Health']
    new_cases = nil
    date = Date.parse(date_string)

    if !last_total_cases.nil? && day_before?(date, last_date)
      new_cases = total_cases - last_total_cases
      val_map['cities_new_cases_from_epidemiologic_summary'] = {
        'Toronto Public Health' => new_cases
      }
    end

    puts "Toronto cases: #{total_cases}, new cases: #{new_cases}"
    last_total_cases = total_cases
    last_date = date
  end
end

raw_reports_glob = File.join(raw_reports_dir, 'epidemiologic-summary-*.pdf')
epidemiologic_report_paths = Dir.glob(raw_reports_glob).sort

scrape_toronto_data = ScrapeTorontoData.new(tabula_path)

date_toronto_map = JSON.parse(File.read(old_toronto_data_path))

existing_dates = date_toronto_map.keys

epidemiologic_report_paths.each do |pdf_path|
  pdf_basename = File.basename(pdf_path)

  date_regex = /epidemiologic-summary-(?<date>\d{4}-\d{2}-\d{2})\.pdf/
  matches = date_regex.match(pdf_basename)

  date = Date.parse(matches[:date])

  # reports are on a different page before this date
  min_date = Date.parse('2020-06-11')

  if date < min_date
    puts "Skipping report for #{date} because it is older than min date #{min_date}"
    next
  elsif existing_dates.include?(date.to_s)
    puts "Skipping report for #{date} because the date already exists in the previously generated report"
    next
  else
    puts "Scraping #{pdf_basename}..."
  end

  data = scrape_toronto_data.scrape(pdf_path)
  date_toronto_map[date.to_s] = data unless data.empty?
end

derive_new_cases(date_toronto_map)

File.write(
  output_report_path,
  JSON.pretty_generate(date_toronto_map.sort.to_h)
)
puts "Wrote city cases from epidemiologic summaries report: #{output_report_path}"
