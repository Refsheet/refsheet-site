## Configure Rack CORS Middleware, so that CloudFront can serve our assets.
## See https://github.com/cyu/rack-cors

def _cors(*urls, ports: [])
  out = urls.collect { |url| [
      'https://' + url,
      'http://' + url
  ]}.flatten

  out | ports.collect { |port| [
      out.collect { |url| [
          url + ":#{port}"
      ]}
  ]}.flatten
end

CORS_PROD = _cors(
    'refsheet.net',
    'www.refsheet.net',
    'ref.st',
    'staging.refsheet.net',
    'kube.refsheet.net',
    'static.refsheet.net',
)

CORS_EXT = _cors(
    'admin.refsheet.net',
    'extension.refsheet.net'
)

CORS_DEV = _cors(
    'dev.refsheet.net',
    'dev1.refsheet.net',
    '127.0.0.1',
    'localhost',
    ports: [3000, 5000, 3200, 3300]
)

if defined? Rack::Cors
  Rails.configuration.middleware.insert_before 0, Rack::Cors do
    allow do
      origins CORS_PROD | CORS_EXT | CORS_DEV
      resource '/assets/*'
    end

    allow do
      origins CORS_PROD | CORS_EXT
      resource '/graphql', headers: :any, methods: [:get, :post, :options], credentials: true
    end

    allow do
      origins CORS_PROD | CORS_EXT
      resource '/session', headers: :any, methods: [:get, :post, :options], credentials: true
    end

    allow do
      origins '*'
      resource '/api/*', headers: :any, methods: :any
    end

    allow do
      origins '*'
      resource '/health.json', headers: :any, methods: [:get]
    end
  end
end
