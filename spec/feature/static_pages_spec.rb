require 'spec_helper'

# require 'support/configuration'

describe "Static pages" do

  # subject { page }

  describe "Home page" do
    before {
      visit "/"
      #save_snapshot(example,"start")
    }
    # after {
    #   save_screenshot("#{path_to_screenshot(example)}/end.png")
    # }
    # it "should have h1 element with text Sample App" do
    #   should have_selector('h1',    text: 'Sample App')
    # end

    it "should have default title", :js => true do
      page.should have_title('Ruby on Rails')
    end

    it "should have default title", :js => true do
      page.should have_title('fail')
    end

    it "should have default title", :js => true do
      # page.should have_content('This is the home page for the')
      page.html.should have_selector("title", :text => "Ruby on Rails Tutorial Sample App", :visible => false)
    end
  end
end