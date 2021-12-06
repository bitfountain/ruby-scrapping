require 'watir'
require 'webdrivers'
require 'mechanize'
require 'nokogiri'
require 'pry';

agent = Mechanize.new
page = agent.get('https://www.tour.ne.jp/j_air/list/?adult=1&air_type=2&arr_out=ITM&change_date_in=0&change_date_out=0&date_out=20211208&dpt_out=CTS')
# puts page.content
File.open("parsed_test.txt", "w") { |f| f.write "#{page.content}" }
# page.search('.ticket-code').each do |link|
page.search('.tbl-list-detail .ticket-detail-type-text-ellipsis').each do |link|
 # print the link text
 binding.pry
 puts link
end


# puts parsed_page.title

# links = parsed_page.css('a')
# links.map {|element| element["href"]}

# puts links

# article_cards = parsed_page.xpath("//*[@id='Act_search_out']/h3")
# article_cards = parsed_page.css(".ticket-detail-type-text-ellipsis")
# article_cards = parsed_page.css(".airline-logo")
# puts article_cards
# binding.pry
# article_cards.each do |card|
#     puts card
#     # puts card.children.first.values unless card.nil?
#     # binding.pry
#     # puts card.children.first.children.first.children.first.children.last.children.first.children.text
#     # puts card unless card.nil?
# end

