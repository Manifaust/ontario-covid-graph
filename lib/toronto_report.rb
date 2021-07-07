# frozen_string_literal: true

require 'csv'
require 'json'

require_relative 'report_date'

class TorontoReport
  def initialize(status_csv_path)
    puts "Creating Toronto Report from csv: #{status_csv_path}"

    populate_entries(status_csv_path)
  end

  def read_date(row)
    ReportDate.new(row['Date'])
  end

  def populate_entries(csv_path)
    csv = CSV.parse(File.read(csv_path), headers: true)

    @entries = {}

    csv.each do |row|
      date = read_date(row)
      entry = create_report_entry(row)
      @entries[date.to_s] = entry
    end
  end

  def create_report_entry(row)
    toronto_data = {}

    val = row['Toronto']

    toronto_data['new_cases'] = val.to_i unless val.nil? || val.empty?

    { toronto: toronto_data }
  end

  def to_json(*args)
    JSON.generate(@entries, *args)
  end
end
