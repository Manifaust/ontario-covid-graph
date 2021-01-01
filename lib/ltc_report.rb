# frozen_string_literal: true

require 'csv'
require 'json'

require_relative 'report_date'

class LtcReport
  CSV_MAPPING = {
    resident_total_cases: 'Total Positive LTC Resident Cases',
    resident_total_deaths: 'Total LTC Resident Deaths'
  }.freeze

  def initialize(status_csv_path)
    puts "Creating Long Term Care Report from csv: #{status_csv_path}"

    populate_entries(status_csv_path)

    populate_new_cases
  end

  def read_date(row)
    ReportDate.new(row['Reported Date'])
  end

  def populate_entries(csv_path)
    csv = CSV.parse(File.read(csv_path), headers: true)

    @entries = {}

    csv.each do |row|
      date = read_date(row)
      entry = create_report_entry(row)

      @entries[date] = entry unless entry.empty?
    end
  end

  def create_report_entry(row)
    data = {}

    CSV_MAPPING.each do |key, col_name|
      val = row[col_name]
      next if val.nil? || val.empty?

      data[key] = val.to_i
    end

    if data.empty?
      {}
    else
      { ltc: data }
    end
  end

  def populate_new_cases
    @entries.each_key do |report_date|
      present_total_cases = resident_total_cases(report_date)
      next if present_total_cases.nil?

      prev_total_cases = resident_total_cases(report_date.prev_day)
      next if prev_total_cases.nil?

      @entries[report_date][:ltc][:resident_new_cases] = present_total_cases - prev_total_cases
    end
  end

  def resident_total_cases(report_date)
    return nil unless @entries.has_key?(report_date)
    return nil unless @entries[report_date].has_key?(:ltc)
    return nil unless @entries[report_date][:ltc].has_key?(:resident_total_cases)

    @entries[report_date][:ltc][:resident_total_cases]
  end

  def previous_day_entry(present_date)
    prev_day = present_date.prev_day

    @entries[prev_day]
  end

  def to_json(*args)
    JSON.generate(@entries, *args)
  end
end
