#!/usr/bin/env ruby

require 'csv'
require 'open3'

page = 9
area = '%20,12,51,88'
tabula_path = 'third_party/tabula/tabula-1.0.3-jar-with-dependencies.jar'
report_path = 'raw_reports/moh-covid-19-report-en-2020-04-17.pdf'

command = <<~SH
  java -jar #{tabula_path} \
    --pages #{page} \
    --area #{area} \
    #{report_path}
SH
stdout, stderr, status = Open3.capture3(command)
raise "Cannot parse pdf: #{stdout} #{stderr}" unless status.success?

long_term_care_home_outbreaks = 0
hospital_outbreaks = 0

cases_section = {}
deaths_section = {}
current_section = nil

CSV.parse(stdout, headers:false).each do |row|
  pp row
  if row[0] == 'Number of confirmed COVID-19 outbreaks'
    long_term_care_home_outbreaks = row[1]
    hospital_outbreaks = row[2]
  end

  if row[0].include?('Total number of cases')
    current_section = cases_section
  end

  if row[0].include?('Total number of deaths')
    current_section = deaths_section
  end

  if !current_section.nil? && row[0].empty?
    current_section[:long_term_care_home_total] = row[1]
    current_section[:hospital_total] = row[2]
  end

  if !current_section.nil? && row[0].include?('residents/patients')
    current_section[:long_term_care_home_residents] = row[1]
    current_section[:hospital_patients] = row[2]
  end

  if !current_section.nil? && row[0].include?('staff')
    current_section[:long_term_care_home_staff] = row[1]
    current_section[:hospital_staff] = row[2]
  end
end

puts "Confirmed outbreaks in long-term care homes: #{long_term_care_home_outbreaks}"
puts "Confirmed outbreaks in hospitals: #{hospital_outbreaks}"

institutions = {
  long_term_care_home_outbreaks: long_term_care_home_outbreaks,
  hospital_outbreaks: hospital_outbreaks,
  cases: cases_section,
  deaths: deaths_section
}
pp institutions

