#!/usr/bin/env ruby

require 'json'

require_relative '../lib/ltc_report'

cases_csv_path = ARGV[0]
output_path = ARGV[1]

report = LtcReport.new(cases_csv_path)

File.write(output_path, JSON.pretty_generate(report))
puts "Wrote Long Term Care report: #{output_path}"

