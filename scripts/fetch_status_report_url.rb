#!/usr/bin/env ruby

require 'selenium-webdriver'
require 'webdrivers/geckodriver'

options = Selenium::WebDriver::Firefox::Options.new
options.headless!
driver = Selenium::WebDriver.for :firefox, options: options

begin
  driver.get('https://data.ontario.ca/dataset/status-of-covid-19-cases-in-ontario')
  download_button = driver.find_element(class: 'dataset-download-link')
  csv_url = download_button.attribute('href')

  puts csv_url
ensure
  driver.quit
end

