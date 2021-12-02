require 'watir'
require 'webdrivers'
require 'nokogiri'
require 'pry';

browser = Watir::Browser.new
browser.goto 'https://www.tour.ne.jp/j_air/list/?adult=1&air_type=2&arr_out=ITM&change_date_in=0&change_date_out=0&date_out=20211208&dpt_out=CTS'
parsed_page = Nokogiri::HTML.parse(browser.html)

File.open("parsed.txt", "w") { |f| f.write "#{parsed_page}" }

browser.close


# puts parsed_page.title

# links = parsed_page.css('a')
# links.map {|element| element["href"]}

# puts links

# article_cards = parsed_page.xpath("//*[@id='Act_search_out']/h3")
# article_cards = parsed_page.css(".ticket-detail-type-text-ellipsis")
article_cards = parsed_page.css(".ticket-detail-list .ticket-detail-item-inner")

article_cards.each do |card|
    binding.pry
    puts card
end


