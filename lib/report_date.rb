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

  def eql?(other)
    other.to_s == to_s
  end

  def prev_day
    ReportDate.new(@date.prev_day.to_s)
  end

  def hash
    to_s.hash
  end

  def day_number
    @date.jd
  end

  def to_s
    @date.to_s
  end
end
