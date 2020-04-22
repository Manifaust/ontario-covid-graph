#!/usr/bin/env ruby

require 'json'
require 'csv'

status_csv_path = ARGV[0]
cities_report_path = ARGV[1]
institutions_report_path = ARGV[2]
final_report_path = ARGV[3]

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

cities = JSON.parse(File.read(cities_report_path))
cities_new_cases_all_dates = cities['new_cases']
cities_total_cases_all_dates = cities['total_cases']
institution_dates = JSON.parse(File.read(institutions_report_path))

def create_report_entries(status_csv_path, csv_mapping)
  report_entries = []

  last_total_cases = nil
  last_new_total_cases = nil

  CSV.parse(File.read(status_csv_path), headers: true).each do |row|
    date = row['Reported Date']

    report_entry = create_report_entry(row, csv_mapping)
    report_entry[:date] = date

    # total cases
    new_total_cases = nil
    unless last_total_cases.nil?
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

  csv_mapping.each do |key, col_name|
    val = row[col_name]
    next if val.nil? || val.empty?

    entry[key] = val.to_i
  end

  entry
end

def inject_cities_data(report_entries, cities_new_cases_all_dates, cities_total_cases_all_dates)
  cities_total_cases_all_dates.each do |date, _|
    report_entry_right_day = report_entries.find do |report_entry|
      report_entry[:date] == date
    end

    if report_entry_right_day.nil?
      report_entry_right_day = { date: date }
      report_entries << report_entry_right_day
    end

    report_entry_right_day[:cities_new_cases] = cities_new_cases_all_dates[date]
    report_entry_right_day[:cities_total_cases] = cities_total_cases_all_dates[date]
  end
end

def inject_institutions_data(report_entries, institution_dates)
  institution_dates.each do |date, institutions_map|
    report_entry_right_day = report_entries.find do |report_entry|
      report_entry[:date] == date
    end

    if report_entry_right_day.nil?
      report_entry_right_day = { date: date }
      report_entries << report_entry_right_day
    end

    report_entry_right_day.merge!(institutions_map)
  end
end

report_entries = create_report_entries(
  status_csv_path,
  csv_mapping
)

inject_cities_data(
  report_entries,
  cities_new_cases_all_dates,
  cities_total_cases_all_dates
)

inject_institutions_data(
  report_entries,
  institution_dates
)

report_entries.sort! { |a, b| a[:date] <=> b[:date] }
File.write(final_report_path, JSON.pretty_generate(report_entries))
puts "Wrote final report: #{final_report_path}"

