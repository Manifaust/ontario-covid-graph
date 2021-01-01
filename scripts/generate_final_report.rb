#!/usr/bin/env ruby

require 'csv'
require 'json'

final_report_path = ARGV.last

reports = ARGV[0...-1].map do |report_path|
  JSON.parse(File.read(report_path))
end

def merge_dates(entries, data_map)
  entries.merge(data_map) do |_, x, y|
    x.merge(y)
  end
end

entries = {}

reports.each do |report|
  entries = merge_dates(entries, report)
end

entries_array = entries.sort.map do |entry|
  date = entry[0]
  map = entry[1]
  map['date'] = date

  map.sort.to_h
end

File.write(final_report_path, JSON.pretty_generate(entries_array))
puts "Wrote final report: #{final_report_path}"

