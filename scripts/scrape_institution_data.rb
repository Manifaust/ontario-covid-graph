# frozen_string_literal: true

require 'csv'
require 'open3'
require 'pdf-reader'

LtcRetireHosScrape = Proc.new do |words|
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

LtcHosScrape = Proc.new do |words|
  long_term = words[-2].delete(',').to_i
  hospital = words[-1].delete(',').to_i
  total = long_term + hospital

  {
    long_term: long_term,
    hospitals: hospital,
    total: total
  }
end

LtcScrape = Proc.new do |words|
  long_term = words[-1].delete(',').to_i
  total = long_term

  {
    long_term: long_term,
    total: total
  }
end

class ScrapeInstitutionData
  class << self
    def scrape(report_path, page, scrape_proc)
      puts "Scraping #{report_path} at page #{page}"
      reader = PDF::Reader.new(report_path)
      page_text = reader.pages[page - 1].text

      rows = page_text.lines.select do |line|
        ends_in_two_numbers?(line)
      end

      pp rows

      {
        institutional_outbreaks: scrape_row(rows, 0, scrape_proc),
        institutional_all_cases: scrape_row(rows, 1, scrape_proc),
        institutional_resident_patient_cases: scrape_row(rows, 2, scrape_proc),
        institutional_staff_cases: scrape_row(rows, 3, scrape_proc),
        institutional_all_deaths: scrape_row(rows, 4, scrape_proc),
        institutional_resident_patient_deaths: scrape_row(rows, 5, scrape_proc),
        institutional_staff_deaths: scrape_row(rows, 6, scrape_proc)
      }
    end

    def scrape_row(rows, target_row, scrape_proc)
      row = rows[target_row]
      words = row.split

      scrape_proc.call(words)
    end

    def ends_in_two_numbers?(line)
      words = line.split

      return false if words.size < 1

      # protect against intro paragraph that ends in a date,
      # which occurs in the institutions page
      return false if line.include?('2020')
      return false if line.include?('January')

      # protect against superscripts
      return false if line.include?('1,2,3')

      if is_a_number?(words[-1])
        return true
      end

      false
    end

    def is_a_number?(potential_number)
      true if Float(potential_number.delete(',')) rescue false
    end
  end
end

