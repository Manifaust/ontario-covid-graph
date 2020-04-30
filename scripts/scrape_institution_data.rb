# frozen_string_literal: true

require 'csv'
require 'open3'
require 'pdf-reader'

class ScrapeInstitutionData
  class << self
    def scrape(report_path, page)
      puts "Scraping #{report_path} at page #{page}"
      reader = PDF::Reader.new(report_path)
      page_text = reader.pages[page - 1].text

      rows = page_text.lines.select do |line|
        ends_in_three_numbers?(line)
      end

      pp rows

      {
        institutional_outbreaks: scrape_row(rows, 0),
        institutional_all_cases: scrape_row(rows, 1),
        institutional_resident_patient_cases: scrape_row(rows, 2),
        institutional_staff_cases: scrape_row(rows, 3),
        institutional_all_deaths: scrape_row(rows, 4),
        institutional_resident_patient_deaths: scrape_row(rows, 5),
        institutional_staff_deaths: scrape_row(rows, 6)
      }
    end

    def scrape_row(rows, target_row)
      row = rows[target_row]
      words = row.split

      long_term = words[-3].delete(',').to_i
      retirement_home = words[-2].delete(',').to_i
      hospital = words[-1].delete(',').to_i
      total = long_term + retirement_home + hospital

      {
        long_term: long_term,
        retirement_home: retirement_home,
        hospitals: hospital,
        total: total
      }
    end

    def ends_in_three_numbers?(line)
      words = line.split

      return false if words.size < 3

      if is_a_number?(words[-1]) &&
         is_a_number?(words[-2]) &&
         is_a_number?(words[-3])
        return true
      end

      false
    end

    def is_a_number?(potential_number)
      true if Float(potential_number.delete(',')) rescue false
    end
  end
end

