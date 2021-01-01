#!/usr/bin/env ruby

require 'json'

require_relative '../lib/toronto_report'

cases_csv_path = ARGV[0]
output_path = ARGV[1]

toronto_report = TorontoReport.new(cases_csv_path)

File.write(output_path, JSON.pretty_generate(toronto_report))
puts "Wrote Toronto statuses report: #{output_path}"
