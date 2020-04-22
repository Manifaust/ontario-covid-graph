#!/usr/bin/env ruby

require 'date'
require 'json'

require_relative 'scrape_toronto_data'

tabula_path = ARGV[0]
raw_reports_dir = ARGV[1]


raw_reports_glob = File.join(raw_reports_dir, 'moh-covid-19-report-en-*.pdf')
epidemiologic_report_paths = Dir.glob(raw_reports_glob).sort

puts 'Found PDFs:'
pp epidemiologic_report_paths

scrape_toronto_data = ScrapeTorontoData.new(tabula_path)

date_toronto_map = {}

epidemiologic_report_paths.each do |pdf_path|
  pdf_basename = File.basename(pdf_path)

  date_regex = /moh-covid-19-report-en-(?<date>\d{4}-\d{2}-\d{2})\.pdf/
  matches = date_regex.match(pdf_basename)

  date = Date.parse(matches[:date])

  puts "Scraping #{pdf_basename}"

  date_toronto_map[date.to_s] = scrape_toronto_data.scrape(pdf_path)
end

pp date_toronto_map.sort.to_h
