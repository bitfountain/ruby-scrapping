require 'rubygems'
require 'selenium-webdriver'
require 'pry'

# This options are for headless execution of the browser so that it don't need to load browser 
# options = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])
# driver = Selenium::WebDriver.for(:firefox, options: options)

driver = Selenium::WebDriver.for :firefox

# driver.navigate.to "https://www.tour.ne.jp/j_air/list/?adult=1&air_type=2&arr_out=ITM&change_date_in=0&change_date_out=0&date_out=20211221&dpt_out=TYO"
driver.navigate.to "https://www.tour.ne.jp/j_air/list/?adult=1&air_type=2&arr_out=ITM&change_date_in=0&change_date_out=0&date_out=20211231&dpt_out=TYO&time_from_out=0600&time_to_out=0700&time_type_out=0"
wait = Selenium::WebDriver::Wait.new(:timeout => 10000)

#Take some time to load the page
sleep(10)

ticket_summary_button = wait.until {
  elements = driver.find_element(:css, "#Act_Airline_Out")
}

sleep(10)

ticket_summary_button.click

sleep(5)

ticket_summary = driver.find_elements(:class, "airline-name")
ticket_available_lists = driver.find_elements(:class, "toggle-btn-company")

# binding.pry

available_ticket = 0

ticket_available_lists.each do |ticket_count|
    available_ticket += ticket_count.text.delete("^0-9").to_i
end
puts "available ticket companies = " + ticket_summary.first.text + ", " + ticket_summary.last.text
puts "Total available ticket found is = " + available_ticket.to_s