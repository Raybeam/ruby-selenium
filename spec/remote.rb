puts "loading support/remote.rb"

require_relative 'support/config'
# require 'rspec'
require 'capybara'
require 'selenium-webdriver'

def set_app_address()
    require 'system/getifaddrs'
    ip = $remote_webserver_ip != nil ? $remote_webserver_ip : System.get_ifaddrs.find{ |socket| socket[1][:inet_addr] != "127.0.0.1" } [1][:inet_addr]
    port = $remote_webserver_port != nil ? $remote_webserver_port : Capybara.current_session.server.port
    Capybara.app_host = "http://#{ip}:#{port}"
    #puts "Registering http://#{ip}:#{port} as root server"
    
end

Capybara.javascript_driver = :selenium
Capybara.default_driver = :selenium

# Capybara remote run
# # init ip
caps = Selenium::WebDriver::Remote::Capabilities.chrome
# caps.version = "8"
caps.platform = :WINDOWS

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(
    app,
    :browser => :remote,
    :url => "http://#{$grid_host}:#{$grid_port}/wd/hub",
    :desired_capabilities => caps
    )
end

RSpec.configure do |config|
  config.include Capybara::DSL

  # this allows each test to use the proper port when using
  # Capybara's "random available port"
  config.before(:each) do
    if $remote_webserver_port == nil && Capybara.current_session.server.nil?
      puts "Could not find port settings, please set $webserver_port in config.php"
    end
    next if $remote_webserver_port == nil && Capybara.current_session.server.nil?
    set_app_address()
  end

end



