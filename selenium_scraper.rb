require 'rubygems'
require 'selenium-webdriver'

driver = Selenium::WebDriver.for :firefox
driver.get "http://www.ypag.ru/cat/komp249/page3880.html"


loop do
driver.find_elements(:css, ".p2 div a").each {|link| link.click}
driver.find_elements(:css, ".p3 a, .firm , .p2 div").each {
|n,r,c|
name = n
region = r
contacts = c

print name.text.center(100)
puts region
puts contacts

}
link = driver.find_element(:xpath, "/html/body/table[5]/tbody/tr/td/a[2]" )[:href]
break if link == "http://www.ypag.ru/cat/komp249/page3780.html"
driver.get "#{link}"
end