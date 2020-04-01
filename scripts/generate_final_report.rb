#!/usr/bin/env ruby

require 'json'

intermediate_reports_dir = ARGV[0]

reports_glob = File.join(intermediate_reports_dir, "moh-covid-19-report-en-*.json")
intermediate_reports = Dir.glob(reports_glob)

DATE_REGEX = %r{moh-covid-19-report-en-(?<date>\d{4}-\d{2}-\d{2})}

intermediate_reports.each do |report|
  file_name = File.basename(report)
  date_string = file_name.match(DATE_REGEX)[:date]
  puts date_string

  json = JSON.parse(File.read(report))
  num_cases_text = json[0]['data'][1][1]['text']
  num_cases = num_cases_text.delete(',').to_i
  puts num_cases
end


