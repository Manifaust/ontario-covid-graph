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

    old_toronto_cases_regex = /^Toronto Public Health (?<cases>\d+)$/

    CSV.parse(stdout, headers: false).each do |row|
      if row[0] == 'Toronto Public Health'
        toronto_cases = row[1]
      # old reports that give weird data when scraped
      elsif row[1] == 'oronto Public Health' || row[1] == 'Toronto Public Health'
        toronto_cases = row[4]
      elsif old_toronto_cases_regex.match(row[0])
        toronto_cases = old_toronto_cases_regex.match(row[0])[:cases]
      end
    end

    if toronto_cases.nil?
      puts 'Could not find cases'
      return {}
    end

    toronto_cases = toronto_cases.delete(',').to_i

    puts "Toronto cases: #{toronto_cases}"
    {
      cities_total_cases_from_epidemiologic_summary: {
        'Toronto Public Health': toronto_cases
      }
    }
  end
end
