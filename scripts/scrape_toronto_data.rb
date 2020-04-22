# frozen_string_literal: true

require 'csv'
require 'open3'

class ScrapeTorontoData
  attr_reader :tabula_path

  def initialize(tabula_path)
    @tabula_path = tabula_path
  end

  def scrape(report_path)
    command = <<~SH
      java -jar #{@tabula_path} \
        --pages all \
        #{report_path}
    SH

    stdout, stderr, status = Open3.capture3(command)
    raise "Cannot parse pdf: #{stdout} #{stderr}" unless status.success?

    toronto_cases = nil

    CSV.parse(stdout, headers: false).each do |row|
      if row[0] == 'Toronto Public Health'
        toronto_cases = row[1].delete(',').to_i
        puts "Toronto cases: #{toronto_cases}"
      end
    end

    return {} if toronto_cases.nil?

    {
      toronto_cases_from_epidemiologic_summary: toronto_cases
    }
  end
end
