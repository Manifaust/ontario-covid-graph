#!/usr/bin/env ruby

require 'csv'
require 'json'

confirmed_cases_csv_path = ARGV[0]
report_path = ARGV[1]

def cities_new_cases(confirmed_cases_csv_path)
  date_new_cases_map = {}
  CSV.parse(File.read(confirmed_cases_csv_path), headers: true).each do |row|
    date = row['Accurate_Episode_Date']
    next if date.nil?

    city = row['Reporting_PHU_City']

    cities_new_cases  = date_new_cases_map.fetch(date, {})

    cases_count = cities_new_cases.fetch(city, 0)

    cities_new_cases[city] = cases_count += 1

    date_new_cases_map[date] = cities_new_cases.sort.to_h
  end
  date_new_cases_map.sort.to_h
end

def cities_total_cases(cities_new_cases)
  date_total_cases_arr = []

  cities_new_cases.sort.each_with_index do |row, i|
    date = row[0]
    new_cases_today = row[1]

    total_cases_today = {}
    if i <= 0
      total_cases_today = new_cases_today
    else
      total_cases_yesterday = date_total_cases_arr[i - 1][1]

      total_cases_today = Marshal.load(Marshal.dump(total_cases_yesterday))
      new_cases_today.each do |city_name, single_city_new_cases|
        single_city_total_cases_yesterday = total_cases_yesterday.fetch(city_name, 0)
        single_city_total_cases = single_city_total_cases_yesterday + single_city_new_cases
        total_cases_today[city_name] = single_city_total_cases
      end
    end

    date_total_cases_arr << [date, total_cases_today.sort.to_h]
  end

  date_total_cases_arr.to_h
end

cities_new_cases = cities_new_cases(confirmed_cases_csv_path)
cities_total_cases = cities_total_cases(cities_new_cases)

cities = {}
cities['new_cases'] = cities_new_cases
cities['total_cases'] = cities_total_cases

File.write(report_path, JSON.pretty_generate(cities))
puts "Wrote cities report: #{report_path}"

