require_relative 'support/config'
require 'capybara'

puts "loading local.rb"

# Capybara local run
Capybara.javascript_driver = :selenium
Capybara.default_driver = :selenium
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.app_host = "http://#{$local_webserver_ip}:#{$local_webserver_port}"