#!/usr/bin/env ruby

require 'json'

require_relative '../lib/vaccine_report'

cases_csv_path = ARGV[0]
output_path = ARGV[1]

report = VaccineReport.new(cases_csv_path)

File.write(output_path, JSON.pretty_generate(report))
puts "Wrote Vaccine report: #{output_path}"

