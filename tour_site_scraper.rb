require 'rubygems'
require 'selenium-webdriver'
require 'pry'

# This options are for headless execution of the browser so that it don't need to load browser 
# options = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])
# driver = Selenium::WebDriver.for(:firefox, options: options)

driver = Selenium::WebDriver.for :firefox
# Generate the search url physically using any date, time and put here, we will make it dynamic later based on requirement
driver.navigate.to "https://www.tour.ne.jp/j_air/list/?adult=1&air_type=2&arr_out=ITM&change_date_in=0&change_date_out=0&date_out=20211231&dpt_out=TYO&time_from_out=0600&time_to_out=0700&time_type_out=0"

# Recursive call until find the ticket summery button after search result page load
def click_ticket_search(driver)
  # Take some time to load the page
  sleep(1)
  ticket_summary_button_location = driver.find_element(:css, "#Act_Airline_Out")

  return ticket_summary_button_location if !ticket_summary_button_location.nil?
  click_ticket_search(driver)
end

ticket_summary_button = click_ticket_search(driver)
ticket_summary_button.click

# Take some time after click on second tab to load ajax html content
sleep(2)

# Find available information and search companies name, this is optional
ticket_summary = driver.find_elements(:class, "airline-name")

#Find available ticke count element
ticket_available_lists = driver.find_elements(:class, "toggle-btn-company")

#Find each companies available ticket and sum to get total available tickets
total_available_ticket = 0
!ticket_available_lists.nil? && ticket_available_lists.each do |ticket_count|
  total_available_ticket += ticket_count.text.delete("^0-9").to_i
end

puts "Available ticket companies name = " + ticket_summary.first.text + ", " + ticket_summary.last.text
puts "Total available ticket found is = " + total_available_ticket.to_s

