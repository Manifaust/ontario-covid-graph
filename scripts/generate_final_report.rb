#!/usr/bin/env ruby

require 'csv'
require 'json'

statuses_report_path = ARGV[0]
institutions_report_path = ARGV[1]
toronto_report_path = ARGV[2]
ltc_report_path = ARGV[3]
final_report_path = ARGV[4]

statuses_report = JSON.parse(File.read(statuses_report_path))
institution_dates = JSON.parse(File.read(institutions_report_path))
toronto_report = JSON.parse(File.read(toronto_report_path))
ltc_report = JSON.parse(File.read(ltc_report_path))

def merge_dates(entries, data_map)
  entries.merge(data_map) do |_, x, y|
    x.merge(y)
  end
end

entries = statuses_report

entries = merge_dates(entries, institution_dates)
entries = merge_dates(entries, toronto_report)
entries = merge_dates(entries, ltc_report)

entries_array = entries.sort.map do |entry|
  date = entry[0]
  map = entry[1]
  map['date'] = date

  map.sort.to_h
end

File.write(final_report_path, JSON.pretty_generate(entries_array))
puts "Wrote final report: #{final_report_path}"

