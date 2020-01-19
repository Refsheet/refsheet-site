def wait_until
  require 'timeout'
  Timeout.timeout(Capybara.default_max_wait_time) do
    sleep(0.1) until (value = yield)
    value
  end
end

class JavascriptError < StandardError; end

Webdrivers::Chromedriver.required_version = "79.0.3945.36"

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  Capybara::Selenium::Driver.load_selenium

  browser_options = ::Selenium::WebDriver::Chrome::Options.new
  browser_options.args << '--headless'
  browser_options.args << '--disable-gpu'
  browser_options.args << '--allow-insecure-localhost'
  browser_options.args << '--no-sandbox'
  browser_options.args << '--window-size=1920,1080'
  browser_options.args << '--disable-dev-shm-usage'
  browser_options.args << '--enable-features=NetworkService,NetworkServiceInProcess'

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end

Capybara.configure do |config|
  config.javascript_driver = :headless_chrome
  config.raise_server_errors = true
  config.default_max_wait_time = 7.seconds
end