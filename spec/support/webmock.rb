require 'webmock/rspec'

RSpec.configure do |config|
  config.include WebMock::API
  WebMock.allow_net_connect!

  config.around :each, :webmock do |ex|
    WebMock.enable!
    WebMock.disable_net_connect!
    ex.run
    WebMock.disable!
    WebMock.allow_net_connect!
  end
end
