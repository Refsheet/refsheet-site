class Freshdesk
  include Singleton

  attr_accessor :domain
  attr_accessor :api_key

  def client
    @client ||= Her::API.new
  end

  def endpoint_url
    "https://#{@domain}.freshdesk.com/api/v2"
  end

  def self.configure
    yield instance
    instance.configure_client
  end

  def configure_client
    raise ArgumentError.new "Domain and API Key must be set." unless @domain and @api_key

    @client ||= Her::API.new

    options = {
        ssl: {
            ca_path: "/usr/lib/ssl/certs"
        }
    }

    @client.setup url: endpoint_url, **options do |c|
      c.use Faraday::Request::BasicAuthentication, @api_key, 'X'
      c.use FaradayMiddleware::EncodeJson
      c.use Her::Middleware::DefaultParseJSON
      c.use Faraday::Adapter::NetHttp
    end

    @client
  end

  class Base
    include Her::Model
    use_api Freshdesk.instance.client
  end
end
