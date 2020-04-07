def wait_until
  require 'timeout'
  Timeout.timeout(Capybara.default_max_wait_time) do
    sleep(0.1) until (value = yield)
    value
  end
end

def find_testid(testid)
  find("[data-testid=\"#{testid}\"]")
end

def click_testid(testid)
  find_testid(testid)&.click
end

def expect_testid(testid)
  expect(page).to have_css("[data-testid=\"#{testid}\"]")
end

def expect_no_testid(testid)
  expect(page).to have_no_css("[data-testid=\"#{testid}\"]")
end

def expect_data(data)
  expect(page).to have_css(data_attr(data))
end

def data_attr(data)
  data.collect { |k,v| "[data-#{k.to_s.gsub('_', '-')}=\"#{v}\"]" }.join('')
end

def expect_no_data(data)
  expect(page).to have_no_css(data_attr(data))
end

def click_href(href)
  find("[href=\"#{href}\"]").click
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
  browser_options.args << '--window-size=1920,2160'
  browser_options.args << '--disable-dev-shm-usage'
  browser_options.args << '--enable-features=NetworkService,NetworkServiceInProcess'

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end

Capybara.configure do |config|
  config.javascript_driver = :headless_chrome
  config.raise_server_errors = true
  config.default_max_wait_time = 7.seconds
end

Capybara::Screenshot.register_driver(:headless_chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end

Capybara::Screenshot.prune_strategy = :keep_last_run