## Configure Rack CORS Middleware, so that CloudFront can serve our assets.
## See https://github.com/cyu/rack-cors

if defined? Rack::Cors
  Rails.configuration.middleware.insert_before 0, Rack::Cors do
    allow do
      origins %w[
                https://refsheet.net
                 http://refsheet.net
                https://www.refsheet.net
                 http://www.refsheet.net
                https://ref.st
                 http://ref.st
            ]
      resource '/assets/*'
    end
  end
end
