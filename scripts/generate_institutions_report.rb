#!/usr/bin/env ruby

require 'date'
require 'json'
require 'pdf-reader'

require_relative 'scrape_institution_data'

tabula_path = ARGV[0]
raw_reports_dir = ARGV[1]
old_institutions_data_path = ARGV[2]
institutions_report_path = ARGV[3]

raw_reports_glob = File.join(raw_reports_dir, 'epidemiologic-summary-*.pdf')
epidemiologic_report_paths = Dir.glob(raw_reports_glob).sort

date_institutions_map = JSON.parse(File.read(old_institutions_data_path))

existing_dates = date_institutions_map.keys

# iterate through each government report
epidemiologic_report_paths.each do |pdf_path|
  pdf_basename = File.basename(pdf_path)

  # get the date of the report
  date_regex = /epidemiologic-summary-(?<date>\d{4}-\d{2}-\d{2})\.pdf/
  matches = date_regex.match(pdf_basename)

  date = Date.parse(matches[:date])

  # reports are on a different page before this date
  min_date = Date.parse('2020-05-19')

  if date < min_date
    puts "Skipping report for #{date} because it is older than min date #{min_date}"
    next
  elsif existing_dates.include?(date.to_s)
    puts "Skipping report for #{date} because it already exists in the last saved report"
    next
  else
    puts "Scraping #{pdf_basename}..."
  end

  date_institutions_map[date.to_s] = ScrapeInstitutionData.scrape(pdf_path, date)
end

# write scraped data to a file
File.write(
  institutions_report_path,
  JSON.pretty_generate(date_institutions_map.sort.to_h)
)
puts "Wrote institutions report: #{institutions_report_path}"

