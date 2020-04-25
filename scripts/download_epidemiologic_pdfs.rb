#!/usr/bin/env ruby

require 'date'
require 'net/http'

RAW_REPORTS_DIR = ARGV[0]

def download
  min_date = Date.parse('2020-04-11')

  date_to_check = min_date

  while date_to_check <= Date.today
    date_to_check = date_to_check.next

    pdf_basename = "moh-covid-19-report-en-#{date_to_check}.pdf"
    pdf_path = File.join(RAW_REPORTS_DIR, pdf_basename)

    url = "https://files.ontario.ca/#{pdf_basename}"

    response = Net::HTTP.get_response(URI.parse(url))
    if response.is_a?(Net::HTTPSuccess)
      File.write(pdf_path, response.body)
      puts "Downloaded #{url}"
    else
      puts "Cannot fetch from url: #{url}"
    end

  end

end

download
