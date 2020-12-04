# frozen_string_literal: true

class TableTitleLookup
  class << self
    def get_title(date, type)
      puts "Finding title for date #{date}, type #{type}"

      case type
      when :outbreak
        row_title_map = [
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
        row_title_map = [
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
          ]
        ]
      when :retirement_home_hospital
        row_title_map = [
          [
            Date.parse('2020-05-19'),
            'Table 4c.'
          ],
          [
            Date.parse('2020-06-11'), # data no longer available after this date
            nil
          ]
        ]
      else
        raise "Unsupported type: #{type}"
      end

      correct_title = nil

      row_title_map.each do |date_scraper_tuple|
        if date >= date_scraper_tuple[0]
          correct_title = date_scraper_tuple[1]
        end
      end

      puts "Title should be #{correct_title}"
      return correct_title
    end
  end
end