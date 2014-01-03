require 'rubygems'
require 'capybara'
require 'capybara/dsl'

Capybara.run_server = false
Capybara.current_driver = :selenium
Capybara.app_host = "http://127.0.0.1:3000"


module MyCapybaraTest
  class Test
    include Capybara::DSL
    def visit_homepage
      visit('/')
    end
  end
end

t = MyCapybaraTest::Test.new
t.visit_homepage