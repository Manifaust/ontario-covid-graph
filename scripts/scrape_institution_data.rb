# frozen_string_literal: true

require 'csv'
require 'open3'
require 'pdf-reader'

LastNumberScrape = lambda do |row|
  words = row.split
  cumulative = words[-1].delete(',').to_i

  cumulative
end

SecondLastNumberScrape = lambda do |row|
  words = row.split
  cumulative = words[-2].delete(',').to_i

  cumulative
end

LtcNumberScrape = lambda do |row|
 rx = /(?<number>[\d\,]*\d+)\s+\d+\.\d\s*\%/

 match = rx.match(row)

 raise "Can't find number" if match.nil?

 match['number'].delete(',').to_i
end

def is_a_number?(potential_number)
  true if Float(potential_number.delete(',')) rescue false
end

def scrape_row(rows, target_row, scrape_proc)
  row = rows[target_row]

  scrape_proc.call(row)
end

EndsInTwoNumbersRowSelect = lambda do |line|
  words = line.split

  return false if words.size < 2

  # protect against intro paragraph that ends in a date,
  # which occurs in the institutions page
  return false if line.include?('2020')
  return false if line.include?('January')

  if is_a_number?(words[-1]) && is_a_number?(words[-2])
    return true
  end

  false
end

PercentOfAlRowSelect = lambda do |line|
  rx = %r[\% of all]

  rx.match(line) != nil
end

OutbreakCollect = lambda do |rows|
  long_term = scrape_row(rows, 0, LastNumberScrape)
  retirement_home = scrape_row(rows, 1, LastNumberScrape)
  hospitals = scrape_row(rows, 2, LastNumberScrape)
  total = long_term + retirement_home + hospitals

  {
    institutional_outbreaks: {
      long_term: long_term,
      retirement_home: retirement_home,
      hospitals: hospitals,
      total: total
    }
  }
end

LtcCollect = lambda do |rows|
  cases_resident = scrape_row(rows, 0, LtcNumberScrape)
  cases_staff = scrape_row(rows, 1, LtcNumberScrape)
  deaths_resident = scrape_row(rows, 2, LtcNumberScrape)
  deaths_staff = scrape_row(rows, 3, LtcNumberScrape)

  {
    institutional_all_cases: {
      long_term: cases_resident + cases_staff,
    },
    institutional_resident_patient_cases: {
      long_term: cases_resident,
    },
    institutional_staff_cases: {
      long_term: cases_staff,
    },
    institutional_all_deaths: {
      long_term: deaths_resident + deaths_staff,
    },
    institutional_resident_patient_deaths: {
      long_term: deaths_resident,
    },
    institutional_staff_deaths: {
      long_term: deaths_staff,
    }
  }
end

LtcCollect2 = lambda do |rows|
  cases_resident = scrape_row(rows, 0, LastNumberScrape)
  cases_staff = scrape_row(rows, 1, LastNumberScrape)
  deaths_resident = scrape_row(rows, 2, LastNumberScrape)
  deaths_staff = scrape_row(rows, 3, LastNumberScrape)

  {
    institutional_all_cases: {
      long_term: cases_resident + cases_staff,
    },
    institutional_resident_patient_cases: {
      long_term: cases_resident,
    },
    institutional_staff_cases: {
      long_term: cases_staff,
    },
    institutional_all_deaths: {
      long_term: deaths_resident + deaths_staff,
    },
    institutional_resident_patient_deaths: {
      long_term: deaths_resident,
    },
    institutional_staff_deaths: {
      long_term: deaths_staff,
    }
  }
end

RetirementHomeHospitalCollect = lambda do |rows|
  {
    institutional_all_cases: {
      retirement_home: scrape_row(rows, 0, SecondLastNumberScrape),
      hospitals: scrape_row(rows, 0, LastNumberScrape)
    },
    institutional_resident_patient_cases: {
      retirement_home: scrape_row(rows, 1, SecondLastNumberScrape),
      hospitals: scrape_row(rows, 1, LastNumberScrape)
    },
    institutional_staff_cases: {
      retirement_home: scrape_row(rows, 2, SecondLastNumberScrape),
      hospitals: scrape_row(rows, 2, LastNumberScrape)
    },
    institutional_all_deaths: {
      retirement_home: scrape_row(rows, 3, SecondLastNumberScrape),
      hospitals: scrape_row(rows, 3, LastNumberScrape)
    },
    institutional_resident_patient_deaths: {
      retirement_home: scrape_row(rows, 4, SecondLastNumberScrape),
      hospitals: scrape_row(rows, 4, LastNumberScrape)
    },
    institutional_staff_deaths: {
      retirement_home: scrape_row(rows, 5, SecondLastNumberScrape),
      hospitals: scrape_row(rows, 5, LastNumberScrape)
    }
  }
end

class ScrapeInstitutionData
  class << self
    def scrape(report_path, date)
      data = {}
      [:outbreak, :ltc, :retirement_home_hospital].each do |type|
        title, row_select, collect = determine_title(date, type)

        if title.nil? && row_select.nil? && collect.nil?
          puts "No longer collecting data for #{type}, skipping"
          next
        end

        page_number = find_page_number(report_path, title)

        if page_number <= 0
          raise 'Cannot find page with that title'
        else
          puts "Outbreak info is on page #{page_number}"
        end

        puts "Scraping #{report_path} at page #{page_number}"
        reader = PDF::Reader.new(report_path)
        page_text = reader.pages[page_number - 1].text

        rows = page_text.lines.select do |line|
          row_select.call(line) == true
        end

        pp rows

        data = deep_merge(data, collect.call(rows))
      end

      sum_data(data)

      data
    end

    def find_page_number(report_path, title)
      reader = PDF::Reader.new(report_path)

      reader.pages.each_with_index do |page, i|
        # sometimes formatting errors push title to second line
        first_two_lines = page.text.downcase.lines[0..1]
        first_two_lines.each do |line|
          if line.start_with?(title.downcase)
            return i + 1
          end
        end
      end

      return 0
    end

    def determine_title(date, type)
      puts "Finding title for date #{date}, type #{type}"

      case type
      when :outbreak
        row_scraper_map = [
          [
            Date.parse('2020-05-19'),
            'outbreaks in institutions and public hospitals',
            EndsInTwoNumbersRowSelect,
            OutbreakCollect
          ],
          [
            Date.parse('2020-06-11'),
            'outbreaks',
            EndsInTwoNumbersRowSelect,
            OutbreakCollect
          ]
        ]
      when :ltc
        row_scraper_map = [
          [
            Date.parse('2020-05-19'),
            'Table 4b.',
            PercentOfAlRowSelect,
            LtcCollect
          ],
          [
            Date.parse('2020-06-11'),
            'Table 2.',
            EndsInTwoNumbersRowSelect,
            LtcCollect2
          ]
        ]
      when :retirement_home_hospital
        row_scraper_map = [
          [
            Date.parse('2020-05-19'),
            'Table 4c.',
            EndsInTwoNumbersRowSelect,
            RetirementHomeHospitalCollect
          ],
          [
            Date.parse('2020-06-11'),
            nil,
            nil,
            nil
          ]
        ]
      else
        raise "Unsupported type: #{type}"
      end

      correct_title = nil
      correct_row_select = nil
      correct_collect = nil

      row_scraper_map.each do |date_scraper_tuple|
        if date >= date_scraper_tuple[0]
          correct_title = date_scraper_tuple[1]
          correct_row_select = date_scraper_tuple[2]
          correct_collect = date_scraper_tuple[3]
        end
      end

      puts "Title should be #{correct_title}"
      return correct_title, correct_row_select, correct_collect
    end

    def sum_data(data)
      data.each do |_, section|
        next if section.key?(:total)

        total = 0
        section.each do |_, v|
          total = total + v
        end

        section[:total] = total
      end
    end

    def deep_merge(entries, data_map)
      entries.merge(data_map) do |_, x, y|
        x.merge(y)
      end
    end
  end
end

