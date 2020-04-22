#!/usr/bin/env ruby

require 'date'
require 'json'

require_relative 'scrape_institution_data'

tabula_path = ARGV[0]
raw_reports_dir = ARGV[1]
old_institutions_data_path = ARGV[2]
institutions_report_path = ARGV[3]

raw_reports_glob = File.join(raw_reports_dir, 'moh-covid-19-report-en-*.pdf')
epidemiologic_report_paths = Dir.glob(raw_reports_glob).sort

puts 'Found PDFs:'
pp epidemiologic_report_paths

scrape_institution_data = ScrapeInstituionData.new(tabula_path)

date_institutions_map = JSON.parse(File.read(old_institutions_data_path))

epidemiologic_report_paths.each do |pdf_path|
  pdf_basename = File.basename(pdf_path)

  date_regex = /moh-covid-19-report-en-(?<date>\d{4}-\d{2}-\d{2})\.pdf/
  matches = date_regex.match(pdf_basename)

  date = Date.parse(matches[:date])

  # reports are on a different page before this date
  min_date = Date.parse('2020-04-09')

  if date < min_date
    puts "Skipping report for #{date} because it is older than min date #{min_date}"
    next
  else
    puts "Scraping #{pdf_basename}"
  end

  date_institutions_map[date.to_s] = scrape_institution_data.scrape(pdf_path)
end

File.write(
  institutions_report_path,
  JSON.pretty_generate(date_institutions_map.sort.to_h)
)
puts "Wrote institutions report: #{institutions_report_path}"
