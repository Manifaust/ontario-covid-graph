#!/usr/bin/env ruby

require 'json'
require 'csv'

status_csv_path = ARGV[0]
report_path = ARGV[1]

csv_mapping = {
  infected: 5,
  resolved: 6,
  deaths: 7,
  total_cases: 9,
  hospitalized: 10,
  icu: 11,
  icu_on_ventilator: 12
}

def create_report_entries(status_csv_path, csv_mapping)
  report_entries = []

  last_total_cases = nil
  last_new_total_cases = nil

  CSV.parse(File.read(status_csv_path), headers: true).each do |row|
    date = row[0]

    report_entry = create_report_entry(row, csv_mapping)
    report_entry[:date] = date

    # total cases
    new_total_cases = nil
    if last_total_cases != nil
      new_total_cases = report_entry[:total_cases] - last_total_cases
      report_entry['new_total_cases'] = new_total_cases
    end

    if last_new_total_cases != nil && last_new_total_cases > 0
      growth_factor_total = '%.2f' % new_total_cases.fdiv(last_new_total_cases)
      report_entry['growth_factor_total_cases'] = growth_factor_total
    end

    last_total_cases = report_entry[:total_cases]
    last_new_total_cases = new_total_cases

    report_entries << report_entry
  end

  report_entries
end

def create_report_entry(row, csv_mapping)
  entry = {}

  csv_mapping.each do |key, col|
    val = row[col]
    next if val.nil? || val.empty?

    entry[key] = val.to_i
  end

  entry
end

report_entries = create_report_entries(status_csv_path, csv_mapping)
File.write(report_path, JSON.pretty_generate(report_entries))
puts "Wrote report: #{report_path}"

