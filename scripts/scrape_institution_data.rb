# frozen_string_literal: true

require 'csv'
require 'open3'
require 'pdf-reader'

LTC_KEYWORDS = [
  'Residents',
  'Health', # care workers
  'Deaths', # among residents/health care
  'workers'
]

LTC_KEYWORDS2 = [
  'Residents*',
  'Health', # care workers
  'Deaths', # among residents/health care
  'workers'
]

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

StartsWithLtcKeywordEndsInTwoNumbersRowSelect = lambda do |line|
  words = line.split

  return false if words.size < 2

  # protect against intro paragraph that ends in a date,
  # which occurs in the institutions page
  return false if line.include?('2020')
  return false if line.include?('January')

  return false unless LTC_KEYWORDS.include?(words[0])

  return true if is_a_number?(words[-1]) && is_a_number?(words[-2])

  false
end

StartsWithLtcKeywordEndsInTwoNumbersRowSelect2 = lambda do |line|
  words = line.split

  return false if words.size < 2

  # protect against intro paragraph that ends in a date,
  # which occurs in the institutions page
  return false if line.include?('2020')
  return false if line.include?('January')

  return false unless LTC_KEYWORDS2.include?(words[0])

  return true if is_a_number?(words[-1]) && is_a_number?(words[-2])

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

LtcTextMunger = lambda do |text|
  lines = text.lines

  lines.map.with_index do |line, i|
    words = line.split

    # if it ends with at least 2 numbers and starts with a number
    next line unless words.size >= 2

    next line unless is_a_number?(words[-1]) && is_a_number?(words[-2]) && is_a_number?(words[0])

    # combine line with previous line
    puts "Found stranded line of digits: #{line.strip}"
    puts "Combining with previous line: #{lines[i - 1].strip}"

    new_line = "#{lines[i - 1].strip} #{line}"
    puts "Resutling new line: #{new_line}"
    new_line
  end.join
end

class ScrapeInstitutionData
  class << self
    def scrape(report_path, date)
      data = {}

      # There are three types of data:
      # 1. Institution outbreaks
      # 2. Cases and deaths from Long Term Care (LTC)
      # 3. Cases and deaths from Retirement homes, and hospitals
      [:outbreak, :ltc, :retirement_home_hospital].each do |type|
        # For each type, determine:
        # 1. The title of the table from the PDF we are looking for
        # 2. The row filter to isolate only the important rows of that table
        # 3. A scraper
        title, row_filter, scraper = determine_title_and_row_filter_and_scraper(date, type)

        if title.nil? && row_filter.nil? && scraper.nil?
          puts "No longer collecting data for #{type}, skipping"
          next
        end

        # Find the page number where the target table appears by looking for the title
        page_number = find_page_number_with_title(report_path, title)

        page_text = get_page_text(report_path, page_number)

        # Clean up the text, filter for text that is inside the target table.
        # Each line of text represents a row in that table.
        rows = page_text.lines.select do |line|
          row_filter.call(line) == true
        end

        # Print found table rows
        puts "Isolated rows from page #{page_number}:"
        pp rows

        # Scrape the rows we have isolated
        puts "Scraping rows for data..."
        data = deep_merge(data, scraper.call(rows))
      end

      # Decorate the data with sums
      sum_data(data)

      data
    end

    def get_page_text(report_path, page_number)
      puts "Getting page text from #{report_path} at page #{page_number}"
      reader = PDF::Reader.new(report_path)

      # Obtain the text from that page
      page_text = reader.pages[page_number - 1].text
      page_text = LtcTextMunger.call(page_text)
    end

    def find_page_number_with_title(report_path, title)
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

    def determine_title_and_row_filter_and_scraper(date, type)
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
          ],
          [
            Date.parse('2020-08-25'),
            'Table 1b.',
            StartsWithLtcKeywordEndsInTwoNumbersRowSelect,
            LtcCollect2
          ],
          [
            Date.parse('2020-10-29'),
            'Table 3.',
            StartsWithLtcKeywordEndsInTwoNumbersRowSelect,
            LtcCollect2
          ],
          [
            Date.parse('2020-12-02'),
            'Table 3.',
            StartsWithLtcKeywordEndsInTwoNumbersRowSelect2,
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
        next if section.keys.empty?

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

