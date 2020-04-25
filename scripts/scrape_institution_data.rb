# frozen_string_literal: true

require 'csv'
require 'open3'

class ScrapeInstituionData
  AREA = '%20,12,51,88'

  attr_reader :tabula_path

  def initialize(tabula_path)
    @tabula_path = tabula_path
  end

  def scrape(report_path, page)
    command = <<~SH
      java -jar #{@tabula_path} \
        --pages #{page} \
        --area #{AREA} \
        #{report_path}
    SH
    stdout, stderr, status = Open3.capture3(command)
    raise "Cannot parse pdf: #{stdout} #{stderr}" unless status.success?

    long_term_outbreaks = 0
    hospital_outbreaks = 0
    total_outbreaks = 0

    cases_section = {}
    deaths_section = {}
    current_section = nil

    CSV.parse(stdout, headers: false).each do |row|
      if row[0] == 'Number of confirmed COVID-19 outbreaks'
        long_term_outbreaks = row[1].delete(',').to_i
        hospital_outbreaks = row[2].delete(',').to_i
        total_outbreaks = long_term_outbreaks + hospital_outbreaks
      end

      if row[0].include?('Total number of cases')
        current_section = cases_section
      end

      if row[0].include?('Total number of deaths')
        current_section = deaths_section
      end

      if !current_section.nil? && row[0].include?('residents/patients')
        current_section[:residents_long_term] = row[1].delete(',').to_i
        current_section[:patients_hospitals] = row[2].delete(',').to_i
      end

      if !current_section.nil? && row[0].include?('staff')
        current_section[:staff_long_term] = row[1].delete(',').to_i
        current_section[:staff_hospital] = row[2].delete(',').to_i
      end
    end

    {
      institutional_outbreaks: {
        long_term: long_term_outbreaks,
        hospitals: hospital_outbreaks,
        total: total_outbreaks
      },
      institutional_cases: cases_section,
      institutional_deaths: deaths_section
    }
  end
end

