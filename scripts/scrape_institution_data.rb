# frozen_string_literal: true

require 'csv'
require 'open3'
require 'pdf-reader'

require_relative 'row_filter_factory'
require_relative 'row_scraper_factory'

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
        title = determine_title_and_row_filter_and_scraper(date, type)
        row_filter = RowFilterFactory.get_row_filter(date, type)
        row_scraper = RowScraperFactory.get_row_scraper(date, type)

        if title.nil? && row_filter.nil? && row_scraper.nil?
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
        data = deep_merge(data, row_scraper.call(rows))
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
            'outbreaks in institutions and public hospitals'
          ],
          [
            Date.parse('2020-06-11'),
            'outbreaks'
          ]
        ]
      when :ltc
        row_scraper_map = [
          [
            Date.parse('2020-05-19'),
            'Table 4b.'
          ],
          [
            Date.parse('2020-06-11'),
            'Table 2.'
          ],
          [
            Date.parse('2020-08-25'),
            'Table 1b.'
          ],
          [
            Date.parse('2020-10-29'),
            'Table 3.'
          ],
          [
            Date.parse('2020-12-02'),
            'Table 3.'
          ]
        ]
      when :retirement_home_hospital
        row_scraper_map = [
          [
            Date.parse('2020-05-19'),
            'Table 4c.'
          ],
          [
            Date.parse('2020-06-11'),
            nil
          ]
        ]
      else
        raise "Unsupported type: #{type}"
      end

      correct_title = nil

      row_scraper_map.each do |date_scraper_tuple|
        if date >= date_scraper_tuple[0]
          correct_title = date_scraper_tuple[1]
        end
      end

      puts "Title should be #{correct_title}"
      return correct_title
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

