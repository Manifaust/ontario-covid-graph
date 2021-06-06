# frozen_string_literal: true

require 'csv'
require 'json'

require_relative 'report_date'

class VaccineReport
  CSV_MAPPING = {
    previous_day_doses: 'previous_day_total_doses_administered',
    total_fully_vaccinated: 'total_individuals_fully_vaccinated',
    total_doses: 'total_doses_administered'
  }.freeze

  def initialize(status_csv_path)
    puts "Creating Vaccine report from csv: #{status_csv_path}"

    populate_entries(status_csv_path)
  end

  def date_header
    'report_date'
  end

  def read_date(row)
    ReportDate.new(row[date_header])
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

      data[key] = val.to_s.delete(',').to_i
    end

    if data.empty?
      {}
    else
      { vaccine: data }
    end
  end

  def to_json(*args)
    JSON.generate(@entries, *args)
  end
end
