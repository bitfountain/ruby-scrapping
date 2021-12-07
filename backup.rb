require 'rubygems'
require 'selenium-webdriver'
require 'pry'


# tour_site = Selenium::WebDriver.for :firefox
# tour_site.get "https://www.tour.ne.jp/j_air/list/?adult=1&air_type=2&arr_out=ITM&change_date_in=0&change_date_out=0&date_out=20211221&dpt_out=TYO"

driver = Selenium::WebDriver.for :firefox
driver.navigate.to "https://www.tour.ne.jp/j_air/list/?adult=1&air_type=2&arr_out=ITM&change_date_in=0&change_date_out=0&date_out=20211221&dpt_out=TYO"
wait = Selenium::WebDriver::Wait.new(:timeout => 10000)


# ticket_details = driver.find_elements(:class, "ticket-detail-type-text-ellipsis")

sleep(10)

ticket_details = wait.until {
  elements = driver.find_elements(:class, "ticket-detail-type-text-ellipsis")
}

# binding.pry




# ticket_details =  tour_site.find_element(:css, ".tbl-list-detail > .ticket-detail-list .ticket-detail-type .ticket-detail-type-text .ticket-detail-type-text-ellipsis")
available_ticket = 0
ticket_details.each do |ticket_info|
  
    splited_ticket = ticket_info.text.to_s.split("|")[1] || ticket_info.text.to_s.split("ー")[1]
    
    available_ticket += splited_ticket.to_i
      binding.pry
    puts ticket_info.text
end

puts available_ticket

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