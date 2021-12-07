require 'rubygems'
require 'selenium-webdriver'
require 'pry'


# tour_site = Selenium::WebDriver.for :firefox
# tour_site.get "https://www.tour.ne.jp/j_air/list/?adult=1&air_type=2&arr_out=ITM&change_date_in=0&change_date_out=0&date_out=20211221&dpt_out=TYO"

# options = Selenium::WebDriver::Chrome::Options.new
# options.add_argument('--headless')
# driver = Selenium::WebDriver.for :firefox, options: options

# options = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])
# driver = Selenium::WebDriver.for(:firefox, options: options)

driver = Selenium::WebDriver.for :firefox

# driver.navigate.to "https://www.tour.ne.jp/j_air/list/?adult=1&air_type=2&arr_out=ITM&change_date_in=0&change_date_out=0&date_out=20211221&dpt_out=TYO"
driver.navigate.to "https://www.tour.ne.jp/j_air/list/?adult=1&air_type=2&arr_out=ITM&change_date_in=0&change_date_out=0&date_out=20211231&dpt_out=TYO&time_from_out=0600&time_to_out=0700&time_type_out=0"
wait = Selenium::WebDriver::Wait.new(:timeout => 10000)
sleep(10)
# driver.find_element(:css, "#Act_Airline_Out").click

# new WebDriverWait(driver, 20).until(ExpectedConditions.elementToBeClickable(By.cssSelector("##Act_Airline_Out"))).click();

ticket_summary_button = wait.until {
  elements = driver.find_element(:css, "#Act_Airline_Out")
}

# ticket_summary_button = wait.until {
#   elements = driver.find_elements(:css, "#Act_Airline_Out")
# }

# binding.pry 

# puts driver


# ticket_details = driver.find_elements(:class, "ticket-detail-type-text-ellipsis")

sleep(10)

# ticket_details = wait.until {
#   elements = driver.find_elements(:class, "ticket-detail-type-text-ellipsis")
# }


# ticket_summary = wait.until {
#   elements = driver.find_elements(:class, "airline-name")
# }

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


# binding.pry


# ticket_details =  tour_site.find_element(:css, ".tbl-list-detail > .ticket-detail-list .ticket-detail-type .ticket-detail-type-text .ticket-detail-type-text-ellipsis")
# available_ticket = 0
# ticket_details.each do |ticket_info|
  
#     splited_ticket = ticket_info.text.to_s.split("|")[1] || ticket_info.text.to_s.split("ー")[1]
    
#     available_ticket += splited_ticket.to_i
#       binding.pry
#     puts ticket_info.text
# end

# puts available_ticket

# binding.pry


# loop do
# driver.find_elements(:css, ".p2 div a").each {|link| link.click}
# driver.find_elements(:css, ".p3 a, .firm , .p2 div").each {
# |n,r,c|
# name = n
# region = r
# contacts = c

# print name.text.center(100)
# puts region
# puts contacts

# }
# link = driver.find_element(:xpath, "/html/body/table[5]/tbody/tr/td/a[2]" )[:href]
# break if link == "http://www.ypag.ru/cat/komp249/page3780.html"
# driver.get "#{link}"
# end