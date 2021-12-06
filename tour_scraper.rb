require 'watir'
require 'webdrivers'
require 'nokogiri'
require 'pry';

browser = Watir::Browser.new :firefox
# browser = Watir::Browser.new
browser.goto 'https://www.tour.ne.jp/j_air/list/?adult=1&air_type=2&arr_out=ITM&change_date_in=0&change_date_out=0&date_out=20211221&dpt_out=TYO'
parsed_page = Nokogiri::HTML.parse(browser.html)
File.open("parsed.txt", "w") { |f| f.write "#{parsed_page}" }
browser.close

available_ticket = 0

#Parse searched page to find out available ticket no.
parsed_page.search('.tbl-list-detail .ticket-detail-type-text-ellipsis').each do |ticket_details|
 # Split the ticket available count
 splited_ticket = ticket_details.to_s.split("|")[1]
 available_ticket += splited_ticket
 binding.pry
end

puts "Total available ticket = "
puts available_ticket


