# frozen_string_literal: true

require 'date'

class ReportDate
  def initialize(date_string)
    @date = parse_date(date_string)
  end

  def parse_date(date_string)
    if date_string.include?('/')
      Date.strptime(date_string, '%m/%d/%Y')
    else
      Date.parse(date_string)
    end
  end

  def day_number
    @date.jd
  end

  def to_s
    @date.to_s
  end
end

