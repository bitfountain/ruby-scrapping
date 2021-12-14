require 'rubygems'
require 'selenium-webdriver'
require 'pry'

MAX_RETRY = 40  # Maximum retry until the serarch page load in seconds
MAX_CALL = 3  # Maximum recall air ticket site if any ajax error or busy page shown
# Put Ticket Search input dates here
TICKET_SEARCH_FROM_DATE = Date.new(2021, 12, 31)
TICKET_SEARCH_TO_DATE = Date.new(2022, 01, 31)

WAIT = Selenium::WebDriver::Wait.new(timeout: 20) # Maximum wait to find out search results html
WEB_DRIVER = Selenium::WebDriver.for :firefox

# options = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])
# driver = Selenium::WebDriver.for(:firefox, options: options)

puts 'Trying to fetch data from site.....'
puts '--------------------------------------------------------'

def start_scraping(departure_date_in, departure_date_out)
  # Generate the search url physically using any date, time and put here, we will make it dynamic later based on requirement
  WEB_DRIVER.navigate.to 'https://www.tour.ne.jp/j_air/list/?adult=1&arr_in=TYO&arr_out=CTS&change_date_in=0&change_date_out=0&date_in=' + departure_date_in + '&date_out=' + departure_date_out + '&dpt_in=CTS&dpt_out=TYO&time_from_out=0600&time_to_out=0700&time_type_out=0'
  sleep(1)  # Wait 1s to load the page properly
  begin
    retries ||= 0
    ticket_summary_button_out = nil
    ticket_summary_button_out = WEB_DRIVER.find_element(:css, '#Act_Airline_Out')
    ticket_summary_button_in = WEB_DRIVER.find_element(:css, '#Act_Airline_In')
    return if ticket_summary_button_out.nil? && ticket_summary_button_in.nil?
    ticket_summary_button_out.click
    ticket_summary_button_in.click
  rescue Exception => e
    puts 'Trying to fetch data.. ' + retries.to_s
    retries += 1
    sleep(1)   # Wait 1s to load the page properly
    retry if (retries <= MAX_RETRY)
    raise "Could not get ticket website information: Please give necessary information to search"
  end
end

def searching_ticket_type(ticket_details_type)
  if ticket_details_type == 'in'
    ticket_airlines = WEB_DRIVER.find_elements(:css, '#Act_response_in .company-list .company-box')
  else
    ticket_airlines = WEB_DRIVER.find_elements(:css, '#Act_response_out .company-list .company-box')
  end

  total_ticket_found = 0
  all_tickets_details_lists = []
  ticket_airlines&.each do |ticket_airline|
    temp_ticket_airline_info = {}
    number_of_ticket_found = 0

    ticket_company_name = ticket_airline.find_element(:css, '.airline-name').text
    number_of_ticket_found = ticket_airline.find_element(:css, '.toggle-btn-company').text.delete('^0-9').to_i
    total_ticket_found += number_of_ticket_found
    ticket_minimum_price = ticket_airline.find_element(:css, '.hdg-sup-price > b').text

    temp_ticket_airline_info[:ticket_company_name] = ticket_company_name
    temp_ticket_airline_info[:ticket_minimum_price] = ticket_minimum_price
    temp_ticket_airline_info[:number_of_ticket_found] = number_of_ticket_found

    ticket_flight_lists = []
    ticket_airline_flights_lists = ticket_airline.find_elements(:css, '.Act_flight_list')
    ticket_airline_flights_lists&.each do |ticket_flight|
      flight_data = {}
      flight_data['flight_code'] = ticket_flight.find_elements(:css, '.ticket-summary-row > span')[1].attribute("innerHTML")
      flight_data['flight_price'] = ticket_flight.find_elements(:css, '.ticket-detail-item .ticket-detail-item-inner .ticket-price > label > b')[0].attribute("innerHTML")
      flight_data['flight_seat'] = ticket_flight.find_elements(:css, '.ticket-detail-item .ticket-detail-item-inner .ticket-detail-type .ticket-detail-icon .icon-seat')[0].attribute("innerHTML")
      flight_data['flight_changable_status'] = ticket_flight.find_elements(:css, '.ticket-detail-item .ticket-detail-item-inner .ticket-detail-type .ticket-detail-icon .icon-date')[0].attribute("innerHTML")
      flight_data['flight_type'] = ticket_flight.find_elements(:css, '.ticket-detail-item .ticket-detail-item-inner .ticket-detail-type .ticket-detail-type-text .ticket-detail-type-text-ellipsis')[0].attribute("innerHTML")
      ticket_flight_lists.push(flight_data)
    end
    temp_ticket_airline_info[:ticket_flight_lists] = ticket_flight_lists
    all_tickets_details_lists.push(temp_ticket_airline_info)
  end
  return all_tickets_details_lists, total_ticket_found
end

TICKET_SEARCH_FROM_DATE.upto(TICKET_SEARCH_TO_DATE) do |dt|
  departure_date_in = dt.to_s.delete("-")
  departure_date_out = dt.to_s.delete("-")

  puts "\n\nTickets for this date " + dt.to_s

  begin
    retries ||= 0
    start_scraping(departure_date_in, departure_date_out)
    # Wait for few seconds until able to find return tickets list
    WAIT.until { WEB_DRIVER.find_element(css: "#Act_response_out .company-list").displayed? }
    WAIT.until { WEB_DRIVER.find_element(css: "#Act_response_in .company-list").displayed? }
    tickets_out_lists = searching_ticket_type('out')
    tickets_in_lists = searching_ticket_type('in')
  rescue Exception
    puts "retris in check visibility=====" + retries.to_s
    retries += 1
    retry if (retries <= MAX_CALL)
    raise "Could not get ticket website information: Please give necessary information to search"
  end

  all_ticket_out_lists = tickets_out_lists[0]
  total_ticket_out_found = tickets_out_lists[1]
  all_ticket_in_details = tickets_in_lists[0]
  total_ticket_in_found = tickets_in_lists[1]

  puts  "Total tickets found for out is = " + total_ticket_out_found.to_s
  puts  "Total tickets found for in is = " + total_ticket_in_found.to_s
end
