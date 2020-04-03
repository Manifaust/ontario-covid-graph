#!/usr/bin/env ruby

require 'json'
require 'csv'

raw_reports_dir = ARGV[0]
final_report_path = ARGV[1]

status_csv = File.join(raw_reports_dir, "covidtesting.csv")

final_report_arr = []

last_confirmed_positive = nil
last_new_cases = nil

CSV.parse(File.read(status_csv), headers: true).each do |row|
  date = row[0]
  confirmed_positive = row[5]
  deaths = row[7]

  next if confirmed_positive.nil? || confirmed_positive.empty?
  confirmed_positive = confirmed_positive.to_i

  final_report_entry = {
    'date': date,
    'confirmed_positive': confirmed_positive
  }
  unless deaths.nil? || deaths.empty?
    final_report_entry['deaths'] = deaths.to_i
  end

  new_cases = nil
  if last_confirmed_positive != nil
    new_cases = confirmed_positive - last_confirmed_positive
    final_report_entry['new_cases'] = new_cases
  end

  if last_new_cases != nil && last_new_cases > 0
    growth_factor = '%.2f' % new_cases.fdiv(last_new_cases)
    final_report_entry['growth_factor'] = growth_factor
  end

  last_confirmed_positive = confirmed_positive
  last_new_cases = new_cases

  final_report_arr << final_report_entry
end

File.write(final_report_path, JSON.pretty_generate(final_report_arr))
puts "Wrote report: #{final_report_path}"

