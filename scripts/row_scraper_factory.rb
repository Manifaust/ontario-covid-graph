# frozen_string_literal: true

class RowScraperFactory
  class << self
    def get_row_scraper(date, type)
      puts "Getting row scraper for date #{date}, type #{type}"

      case type
      when :outbreak
        row_scraper_map = [
          [
            Date.parse('2020-05-19'),
            OutbreakCollect
          ]
        ]
      when :ltc
        row_scraper_map = [
          [
            Date.parse('2020-05-19'),
            LtcCollect
          ],
          [
            Date.parse('2020-06-11'),
            LtcCollect2
          ]
        ]
      when :retirement_home_hospital
        row_scraper_map = [
          [
            Date.parse('2020-05-19'),
            RetirementHomeHospitalCollect
          ],
          [
            Date.parse('2020-06-11'), # data no longer available after this date
            nil
          ]
        ]
      else
        raise "Unsupported type: #{type}"
      end

      correct_row_scraper = nil

      row_scraper_map.each do |date_scraper_tuple|
        if date >= date_scraper_tuple[0]
          correct_row_scraper = date_scraper_tuple[1]
        end
      end

      return correct_row_scraper
    end
  end
end

def scrape_row(rows, target_row, scrape_proc)
  row = rows[target_row]

  scrape_proc.call(row)
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

  ltc_stats = {
    institutional_resident_patient_cases: {
      long_term: cases_resident
    },
    institutional_all_deaths: {
      long_term: deaths_resident + deaths_staff
    },
    institutional_resident_patient_deaths: {
      long_term: deaths_resident
    },
    institutional_staff_deaths: {
      long_term: deaths_staff
    }
  }

  if cases_staff.nil?
    ltc_stats[:institutional_all_cases] = {}
    ltc_stats[:institutional_staff_cases] = {}
  else
    ltc_stats[:institutional_all_cases] = {
      long_term: cases_resident + cases_staff
    }
    ltc_stats[:institutional_staff_cases] = {
      long_term: cases_staff
    }
  end

  ltc_stats
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

LastNumberScrape = lambda do |row|
  words = row.split
  last_word = words[-1]

  return nil if last_word == 'N/A'

  cumulative = last_word.delete(',').to_i

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
  return true if potential_number == 'N/A'

  true if Float(potential_number.delete(',')) rescue false
end
