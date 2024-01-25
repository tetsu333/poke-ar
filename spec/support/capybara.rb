require "capybara/rspec"
require "selenium-webdriver"

Capybara.register_driver :remote_chrome do |app|
  url = "http://#{ENV.fetch("SELENIUM_HOST")}/wd/hub"
  caps = ::Selenium::WebDriver::Options.chrome(
    "goog:chromeOptions" => {
      "args" => [
        "no-sandbox",
        "headless",
        "disable-gpu",
        "window-size=1680,1050",
        "disable-dev-shm-usage"
      ]
    }
  )
  Capybara::Selenium::Driver.new(app, browser: :remote, url: url, capabilities: caps)
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :remote_chrome
    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
  end
end
