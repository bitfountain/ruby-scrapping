require 'watir'
require 'webdrivers'
require 'nokogiri'
require 'pry';

# require "selenium-webdriver"

# driver = Selenium::WebDriver.for :firefox
# driver.navigate.to "http://google.com"

# element = driver.find_element(name: 'q')
# element.send_keys "Hello WebDriver!"
# element.submit

# puts driver

# driver.quit


# browser = Watir::Browser.new :firefox
# browser_opts = {"script-timeout"=> 30}
# browser = Watir::Browser.new :chrome, headless: true
browser = Watir::Browser.new :chrome
browser.driver.manage.timeouts.implicit_wait  = 30

# browser.add_argument('--ignore-certificate-errors')
# browser.add_argument('--disable-popup-blocking')
# browser.add_argument('--disable-translate')
# browser = Watir::Browser.new
# browser = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36';
browser.goto 'https://www.tour.ne.jp/j_air/list/?adult=1&air_type=2&arr_out=ITM&change_date_in=0&change_date_out=0&date_out=20211221&dpt_out=TYO'

parsed_page = Nokogiri::HTML.parse(browser.html)
#parsed_page = Nokogiri::HTML(open('https://www.tour.ne.jp/j_air/list/?adult=1&air_type=2&arr_out=ITM&change_date_in=0&change_date_out=0&date_out=20211208&dpt_out=CTS', browser))

File.open("parsed.txt", "w") { |f| f.write "#{parsed_page}" }

browser.close

parsed_page.search('.tbl-list-detail .ticket-detail-type-text-ellipsis').each do |ticket_details|
 # print the link text
 splited_ticket = ticket_details.to_s.split("|")[1]
 binding.pry
 puts ticket_details
end

puts "-----------------------------------------"
# article_cards = parsed_page.xpath("//*[@id='Act_search_out']/h3")
# article_cards = parsed_page.css(".ticket-detail-type-text-ellipsis")
article_cards = parsed_page.css(".airline-logo")
# puts article_cards
# binding.pry
article_cards.each do |card|
    puts card
    # puts card.children.first.values unless card.nil?
    # binding.pry
    # puts card.children.first.children.first.children.first.children.last.children.first.children.text
    # puts card unless card.nil?
end

