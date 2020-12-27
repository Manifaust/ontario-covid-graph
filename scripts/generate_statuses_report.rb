#!/usr/bin/env ruby

require 'csv'
require 'json'

require_relative 'report_date'

status_csv_path = ARGV[0]
output_path = ARGV[1]

csv_mapping = {
  infected: 'Confirmed Positive',
  resolved: 'Resolved',
  deaths: 'Deaths',
  total_cases: 'Total Cases',
  new_tests: 'Total tests completed in the last day',
  under_investigation: 'Under Investigation',
  hospitalized: 'Number of patients hospitalized with COVID-19',
  icu: 'Number of patients in ICU with COVID-19',
  icu_on_ventilator: 'Number of patients in ICU on a ventilator with COVID-19'
}

def create_report_entries(status_csv_path, csv_mapping)
  report_entries = {}

  last_total_cases = nil
  last_new_total_cases = nil
  last_new_weekly_total_cases = nil
  weekly_new_cases = []

  CSV.parse(File.read(status_csv_path), headers: true).each_with_index do |row, index|
    report_entry = create_report_entry(row, csv_mapping)

    # total cases
    new_total_cases = nil
    unless last_total_cases.nil?
      total_cases = report_entry[:total_cases]

      if total_cases.nil?
        puts "Skipping row with no 'Total Cases' at index #{index}:"
        pp row
        next
      end

      new_total_cases = total_cases - last_total_cases
      report_entry['new_total_cases'] = new_total_cases
      weekly_new_cases.push(new_total_cases)
    end

    if last_new_total_cases != nil && last_new_total_cases > 0
      growth_factor_total = '%.2f' % new_total_cases.fdiv(last_new_total_cases)
      report_entry['growth_factor_total_cases'] = growth_factor_total
    end

    date = ReportDate.new(row['Reported Date'])
    day_number = date.day_number

    if (day_number % 7).zero?
      weekly_new_cases_sum = weekly_new_cases.sum

      if last_new_weekly_total_cases != nil
        weekly_growth_factor_total = '%.2f' % weekly_new_cases_sum.fdiv(last_new_weekly_total_cases)
        report_entry['weekly_growth_factor_total_cases'] = weekly_growth_factor_total
      end

      last_new_weekly_total_cases = weekly_new_cases_sum
      weekly_new_cases.clear
    end

    last_total_cases = report_entry[:total_cases]
    last_new_total_cases = new_total_cases

    report_entries[date.to_s] = report_entry
  end

  report_entries
end

def create_report_entry(row, csv_mapping)
  entry = {}

  csv_mapping.each do |key, col_name|
    val = row[col_name]
    next if val.nil? || val.empty?

    entry[key] = val.to_i
  end

  entry
end

statuses = create_report_entries(
  status_csv_path,
  csv_mapping
)
File.write(output_path, JSON.pretty_generate(statuses))
puts "Wrote statuses report: #{output_path}"

