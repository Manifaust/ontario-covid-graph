#!/usr/bin/env ruby

require 'date'
require 'net/http'

RAW_REPORTS_DIR = ARGV[0]

def download_pdf(pdf_basename, output_filepath)

  url = "https://files.ontario.ca/#{pdf_basename}"

  response = Net::HTTP.get_response(URI.parse(url))
  if response.is_a?(Net::HTTPSuccess)
    File.write(output_filepath, response.body)
    puts "Downloaded #{url} to #{output_filepath}"
    return true
  else
    puts "Cannot fetch from url: #{url}"
    return false
  end
end

def download_all
  min_date = Date.parse('2020-04-11')

  date_to_check = min_date

  while date_to_check <= Date.today
    date_to_check = date_to_check.next
    output_filepath = File.join(
      RAW_REPORTS_DIR,
      "epidemiologic-summary-#{date_to_check}.pdf"
    )

    if File.exist?(output_filepath)
      puts "epidemiologic summary for #{date_to_check} already exists, skip downloading"
      next
    end

    pdf_basename = "moh-covid-19-report-en-#{date_to_check}.pdf"
    success = download_pdf(pdf_basename, output_filepath)

    unless success
      backup_basename = "moh-covid-19-report-#{date_to_check}-en.pdf"
      download_pdf(backup_basename, output_filepath)
    end
  end
end

download_all
