#!/usr/bin/env ruby

require 'date'

require_relative 'scrape_institution_data'

tabula_path = 'third_party/tabula/tabula-1.0.3-jar-with-dependencies.jar'
report_path = 'raw_reports/moh-covid-19-report-en-2020-04-17.pdf'

raw_reports_glob = File.join('raw_reports', 'moh-covid-19-report-en-*.pdf')
epidemiologic_report_paths = Dir.glob(raw_reports_glob)

puts 'Found PDFs:'
pp epidemiologic_report_paths

scrape_institution_data = ScrapeInstituionData.new(tabula_path)

date_institutions_map = {}

epidemiologic_report_paths.each do |pdf_path|
  pdf_basename = File.basename(pdf_path)

  date_regex = /moh-covid-19-report-en-(?<date>\d{4}-\d{2}-\d{2})\.pdf/
  matches = date_regex.match(pdf_basename)

  date = Date.parse(matches[:date])

  min_date = Date.parse('2020-04-09')

  if date < min_date
    puts "Skipping because report for #{date} older than min date #{min_date}"
    next
  else
    puts "Scraping #{pdf_basename}"
  end

  date_institutions_map[date.to_s] = scrape_institution_data.scrape(pdf_path)
end

pp date_institutions_map

