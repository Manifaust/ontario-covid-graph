#!/usr/bin/env ruby

require 'json'
require 'csv'

raw_reports_dir = ARGV[0]
final_report_path = ARGV[1]

status_csv = File.join(raw_reports_dir, "covidtesting.csv")

final_report_arr = []

CSV.parse(File.read(status_csv), headers: true).each do |row|
  date = row[0]
  confirmed_positive = row[5]
  deaths = row[7]

  next if confirmed_positive.nil? || confirmed_positive.empty?

  puts "#{date} #{confirmed_positive} #{deaths}"

  final_report_entry = {
    'date': date,
    'confirmed_positive': confirmed_positive.to_i,
  }
  unless deaths.nil? || deaths.empty?
    final_report_entry['deaths'] = deaths.to_i
  end

  final_report_arr << final_report_entry
end

File.write(final_report_path, JSON.pretty_generate(final_report_arr))

