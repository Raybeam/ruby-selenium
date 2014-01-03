# require 'rubygems'
require 'capybara'
# require 'capybara/dsl'

RSpec.configure do |config|
  include Capybara::DSL
  Capybara.run_server = false
  Capybara.current_driver = :selenium
  Capybara.app_host = "http://127.0.0.1:3000"
end