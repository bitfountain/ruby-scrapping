require 'watir'
require 'nokogiri'
require 'open-uri'
 
#instance of watir webdriver where we open the page with firefox
browser = Watir::Browser.new
#self explanatory
browser.goto "http://www.vindexfunding.com/all-funding-projects/"
# giving some time for website to load
sleep 2
 
# start a nokogiri instance where we store the page's html
data = Nokogiri::HTML(browser.html)
 
#we will use this to store the links to individual projects so we can go to those pages later
link_to_individual_projects = []
 
#all the projects are within the div with id category-menu
active_projects = data.css('#category-menu') #
 
# loop through the categories and get their link
active_projects.css('a').each do |link_tag|
  browser.link(:text => link_tag.text).when_present.click
  sleep 1
  ajax_called_data = Nokogiri::HTML(browser.html)
  card_name = ajax_called_data.css('.bbcard_name') # card where project is
  link_to_project = card_name.css('a').attribute('href').value # href to project
  link_to_individual_projects << link_to_project
end
 
# let's store here the backers for these projects. We are storing them no matter how much they have donated
backers_array = []
 
# Go each individual page and collect the backer's name
link_to_individual_projects.each do |page|
 browser.goto(page)
 sleep 2
 
 browser.link(:text => "Backers")
 backers_tab = Nokogiri::HTML(browser.html)
 
 funders = backers_tab.css('#project-funders')
 backers_array << funders.text.strip
end
 
# Setting up part where we rank the backers
rank = Hash.new(0)
 
# iterate over the array, counting duplicate entries
backers_array.each do |backers_name|
  rank[backers_name] += 1
end
 
# show who the good souls are
rank.each do |name, number|
  puts "#{name} appears #{number} times"
end