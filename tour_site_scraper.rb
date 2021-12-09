require 'rubygems'
require 'selenium-webdriver'
require 'pry'

# This options are for headless execution of the browser so that it don't need to load browser 
# options = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])
# driver = Selenium::WebDriver.for(:firefox, options: options)

driver = Selenium::WebDriver.for :firefox
puts 'Trying to fetch data from site.....'
puts '--------------------------------------------------------'

# Generate the search url physically using any date, time and put here, we will make it dynamic later based on requirement
driver.navigate.to 'https://www.tour.ne.jp/j_air/list/?adult=1&air_type=2&arr_out=ITM&change_date_in=0&change_date_out=0&date_out=20211231&dpt_out=TYO&time_from_out=0600&time_to_out=0700&time_type_out=0'
sleep(1)  # Wait 1s to load the page properly

MAX_RETRY = 100
begin
  retries ||= 0
  ticket_summary_button = driver.find_element(:css, '#Act_Airline_Out')
  return if ticket_summary_button.nil?
  ticket_summary_button.click
rescue Exception => e
  puts 'Trying to fetch data.. ' + retries.to_s
  retries += 1
  sleep(1)     # Wait 1s to load the page properly
  retry if (retries <= MAX_RETRY)
  raise "Could not get ticket website information: Please give necessary information to search"
end

# Take some time after click to load ajax content until search element can be found
loop do
  sleep(1)
  if !driver.find_elements(:class, 'airline-name').nil?
    break
  end
end

# Find available information and available ticket list elements
ticket_summary = driver.find_elements(:class, 'airline-name')
ticket_available_lists = driver.find_elements(:class, 'toggle-btn-company')

# Parse elements to find each companies available ticket and sum to get total available tickets
total_available_ticket = 0
!ticket_available_lists.nil? && ticket_available_lists.each do |ticket_count|
  total_available_ticket += ticket_count.text.delete('^0-9').to_i
end

puts 'Available ticket companies name = '
!ticket_summary.nil? && ticket_summary.each do |ticket_cmpany|
  puts ticket_cmpany.text.to_s + ', ' 
end
puts 'Total available ticket found is = ' + total_available_ticket.to_s
