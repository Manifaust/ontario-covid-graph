# frozen_string_literal: true

class RowFilterFactory
  class << self
    def get_row_filter(date, type)
      puts "Getting row filter for date #{date}, type #{type}"

      case type
      when :outbreak
        row_filter_map = [
          [
            Date.parse('2020-05-19'),
            EndsInTwoNumbersRowSelect,
          ]
        ]
      when :ltc
        row_filter_map = [
          [
            Date.parse('2020-05-19'),
            PercentOfAlRowSelect,
          ],
          [
            Date.parse('2020-06-11'),
            EndsInTwoNumbersRowSelect,
          ],
          [
            Date.parse('2020-08-25'),
            StartsWithLtcKeywordEndsInTwoNumbersRowSelect,
          ],
          [
            Date.parse('2020-12-02'),
            StartsWithLtcKeywordEndsInTwoNumbersRowSelect2,
          ]
        ]
      when :retirement_home_hospital
        row_filter_map = [
          [
            Date.parse('2020-05-19'),
            EndsInTwoNumbersRowSelect,
          ],
          [
            Date.parse('2020-06-11'), # data not available after this date
            nil
          ]
        ]
      else
        raise "Unsupported type: #{type}"
      end

      correct_row_filter = nil

      row_filter_map.each do |date_filter_tuple|
        if date >= date_filter_tuple[0]
          correct_row_filter = date_filter_tuple[1]
        end
      end

      return correct_row_filter
    end
  end
end

LTC_KEYWORDS = [
  'Residents',
  'Health', # care workers
  'Deaths', # among residents/health care
  'workers'
]

LTC_KEYWORDS2 = [
  'Residents*', 'Residents',
  'Health', # care workers
  'Deaths', # among residents/health care
  'workers'
]

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
