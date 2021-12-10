require 'rubygems'
require 'selenium-webdriver'
require 'pry'

MAX_RETRY = 100
WAIT = Selenium::WebDriver::Wait.new(timeout: 20)

# options = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])
# driver = Selenium::WebDriver.for(:firefox, options: options)
driver = Selenium::WebDriver.for :firefox

puts 'Trying to fetch data from site.....'
puts '--------------------------------------------------------'

def check_return_tickets_visibility(driver)
  begin
    # Wait for few seconds until able to find return tickets list
    WAIT.until { driver.find_element(css: "#Act_response_in .toggle-btn-company").displayed? }
    WAIT.until { driver.find_element(css: "#Act_response_in .airline-name").displayed? }
  rescue Exception
  end
end

ticket_search_date_from = Date.new(2021, 12, 31)
ticket_search_date_to = Date.new(2022, 01, 31)
ticket_search_date_from.upto(ticket_search_date_to) do |dt|
  departure_date_in = dt.to_s.delete("-")
  departure_date_out = dt.to_s.delete("-")

  puts "\n\nTickets for this date " + dt.to_s

  # Generate the search url physically using any date, time and put here, we will make it dynamic later based on requirement
  driver.navigate.to 'https://www.tour.ne.jp/j_air/list/?adult=1&arr_in=TYO&arr_out=CTS&change_date_in=0&change_date_out=0&date_in=' + departure_date_in + '&date_out=' + departure_date_out + '&dpt_in=CTS&dpt_out=TYO&time_from_out=0600&time_to_out=0700&time_type_out=0'
  sleep(1)  # Wait 1s to load the page properly
  begin
    retries ||= 0
    ticket_summary_button_out = nil
    ticket_summary_button_out = driver.find_element(:css, '#Act_Airline_Out')
    ticket_summary_button_in = driver.find_element(:css, '#Act_Airline_In')
    return if ticket_summary_button_out.nil? && ticket_summary_button_in.nil?
    ticket_summary_button_out.click
    ticket_summary_button_in.click

    WAIT.until { driver.find_element(css: "#Act_response_out .toggle-btn-company").displayed? }
    WAIT.until { driver.find_element(css: "#Act_response_out .airline-name").displayed? }
  rescue Exception => e
    puts 'Trying to fetch data.. ' + retries.to_s
    retries += 1
    sleep(1)   # Wait 1s to load the page properly
    retry if (retries <= MAX_RETRY)
    raise "Could not get ticket website information: Please give necessary information to search"
  end

  check_return_tickets_visibility(driver)

  # Scrap Available Tickets Elements
  ticket_summary = driver.find_elements(:css, '#Act_response_out .airline-name')
  ticket_available_lists = driver.find_elements(:css, '#Act_response_out .toggle-btn-company')

  # Parse elements to find each companies available ticket and sum
  total_available_ticket = 0
  !ticket_available_lists.nil? && ticket_available_lists.each do |ticket_count|
    total_available_ticket += ticket_count.text.delete('^0-9').to_i
  end

  # Scrap Returning Tickets Elements
  ticket_summary_in = driver.find_elements(:css, '#Act_response_in .airline-name')
  ticket_available_lists_in = driver.find_elements(:css, '#Act_response_in .toggle-btn-company')

  # Parse elements to find each companies returning tickets and sum
  total_available_ticket_in = 0
  !ticket_available_lists_in.nil? && ticket_available_lists_in.each do |ticket_count_in|
    total_available_ticket_in += ticket_count_in.text.delete('^0-9').to_i
  end

  # Write all tickets search results
  puts 'Total available ticket OUT found is = ' + total_available_ticket.to_s
  puts 'Total available ticket IN found is = ' + total_available_ticket_in.to_s

  puts 'Available ticket IN companies name : '
  puts '------------------------------------'
  !ticket_summary_in.nil? && ticket_summary_in.each do |ticket_cmpany_in|
    puts ticket_cmpany_in.text.to_s + ', '
  end

  puts
  puts 'Available ticket OUT companies name : '
  puts '-------------------------------------'
  !ticket_summary.nil? && ticket_summary.each do |ticket_cmpany|
    puts ticket_cmpany.text.to_s + ', '
  end
end
