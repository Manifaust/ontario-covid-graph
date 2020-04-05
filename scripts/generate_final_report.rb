#!/usr/bin/env ruby

require 'json'
require 'csv'

status_csv_path = ARGV[0]
final_report_path = ARGV[1]

final_report_arr = []

last_total_cases = nil
last_new_total_cases = nil

CSV.parse(File.read(status_csv_path), headers: true).each do |row|
  date = row[0]
  infected_cases = row[5]
  resolved = row[6]
  deaths = row[7]
  total_cases = row[9]

  next if total_cases.nil? || total_cases.empty?
  total_cases = total_cases.to_i
  infected_cases = infected_cases.to_i

  final_report_entry = {
    'date': date,
    'infected_cases': infected_cases,
    'total_cases': total_cases
  }
  unless deaths.nil? || deaths.empty?
    final_report_entry['deaths'] = deaths.to_i
  end
  unless resolved.nil? || resolved.empty?
    final_report_entry['resolved'] = resolved.to_i
  end

  # total cases
  new_total_cases = nil
  if last_total_cases != nil
    new_total_cases = total_cases - last_total_cases
    final_report_entry['new_total_cases'] = new_total_cases
  end

  if last_new_total_cases != nil && last_new_total_cases > 0
    growth_factor_total = '%.2f' % new_total_cases.fdiv(last_new_total_cases)
    final_report_entry['growth_factor_total_cases'] = growth_factor_total
  end

  last_total_cases = total_cases
  last_new_total_cases = new_total_cases

  final_report_arr << final_report_entry
end

File.write(final_report_path, JSON.pretty_generate(final_report_arr))
puts "Wrote report: #{final_report_path}"

