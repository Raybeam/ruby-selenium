require_relative 'support/config'
require 'capybara'

require 'capybara/poltergeist'
Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

Capybara.app_host = "http://#{$local_webserver_ip}:#{$local_webserver_port}"