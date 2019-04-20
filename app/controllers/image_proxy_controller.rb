class ImageProxyController < ApplicationController
  before_action :validate_token

  def get
    image = Net::HTTP.get_response(@url)
    send_data image.body, type: image.content_type, disposition: 'inline'
  end

  def self.generate(url)
    if Rails.env.development?
      return url
    end

    encoded = generate_parts url

    url_options = {
        host: 'ref.st',
        protocol: :https,
        url: encoded.token,
        key: encoded.key
    }

    Rails.application.routes.url_helpers.image_proxy_url url_options
  end

  def self.generate_parts(url)
    token  = Base64.encode64(URI.encode(url)).chomp
    key    = Rails.configuration.x.image_proxy[:secret]
    digest = OpenSSL::Digest.new('sha1')
    hmac   = OpenSSL::HMAC.hexdigest(digest, key, token)

    OpenStruct.new token: token,
                   key:   hmac
  end

  private

  def validate_token
    @url   = URI.parse(Base64.decode64(params[:url]))

    key    = Rails.configuration.x.image_proxy[:secret]
    digest = OpenSSL::Digest.new('sha1')
    hmac   = OpenSSL::HMAC.hexdigest(digest, key, params[:url])

    unless params[:key] == hmac
      head :teapot
    end
  end
end
