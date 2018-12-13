## Configure Rack CORS Middleware, so that CloudFront can serve our assets.
## See https://github.com/cyu/rack-cors

def _cors(*urls)
  urls.collect { |url| [
      'https://' + url,
      'http://' + url
  ] }.flatten
end

CORS_PROD = _cors(
    'refsheet.net',
    'www.refsheet.net',
    'ref.st'
)

CORS_EXT = _cors(
    'extension.refsheet.net'
)

CORS_DEV = _cors(
    'dev.refsheet.net',
    '127.0.0.1',
    'localhost'
)

if defined? Rack::Cors
  Rails.configuration.middleware.insert_before 0, Rack::Cors do
    allow do
      origins CORS_PROD | CORS_DEV
      resource '/assets/*'
    end

    allow do
      origins CORS_PROD | CORS_EXT | CORS_DEV
      resource '/graphql', headers: :any, methods: [:get, :post, :options]
    end
  end
end
