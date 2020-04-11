#!/usr/bin/env ruby

require 'selenium-webdriver'
require 'webdrivers/chromedriver'

options = Selenium::WebDriver::Chrome::Options.new
options.headless!
driver = Selenium::WebDriver.for :chrome, options: options

page_url = ARGV[0]
csv_name = ARGV[1]

begin
  driver.get(page_url)
  download_button = driver.find_element(:xpath, "//a[contains(@href,'#{csv_name}')]")

  csv_url = download_button.attribute('href')

  puts csv_url
ensure
  driver.quit
end

