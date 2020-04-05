#!/usr/bin/env ruby

require 'json'
require 'csv'

status_csv_path = ARGV[0]
final_report_path = ARGV[1]

final_report_arr = []

last_infected_cases = nil
last_new_infected_cases = nil
last_total_cases = nil
last_new_total_cases = nil

CSV.parse(File.read(status_csv_path), headers: true).each do |row|
  date = row[0]
  infected_cases = row[5]
  total_deaths = row[7]
  total_cases = row[9]

  next if total_cases.nil? || total_cases.empty?
  total_cases = total_cases.to_i
  infected_cases = infected_cases.to_i

  final_report_entry = {
    'date': date,
    'infected_cases': infected_cases,
    'total_cases': total_cases
  }
  unless total_deaths.nil? || total_deaths.empty?
    final_report_entry['total_deaths'] = total_deaths.to_i
  end

  # infected cases
  new_infected_cases = nil
  if last_infected_cases != nil
    new_infected_cases = infected_cases - last_infected_cases
    final_report_entry['new_infected_cases'] = new_infected_cases
  end

  if last_new_infected_cases != nil && last_new_infected_cases > 0
    growth_factor_infected = '%.2f' % new_infected_cases.fdiv(last_new_infected_cases)
    final_report_entry['growth_factor_infected_cases'] = growth_factor_infected
  end

  last_infected_cases = infected_cases
  last_new_infected_cases = new_infected_cases

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

