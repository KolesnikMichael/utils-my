require 'watir-webdriver'
require 'pry'

browser = Watir::Browser.new :chrome
browser.goto "http://google.com"
browser.text_field(:name => 'q').set("WebDriver rocks!")
browser.button(:name => 'btnG').click
puts browser.url
binding.pry
browser.close
