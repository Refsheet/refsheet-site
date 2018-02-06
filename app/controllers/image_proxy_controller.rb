class ImageProxyController < ApplicationController
  before_action :validate_token

  def get
    image = Net::HTTP.get_response(@url)
    send_data image.body, type: image.content_type, disposition: 'inline'
  end

  def self.generate(url)
    encoded = generate_parts url
    Rails.application.routes.url_helpers.image_proxy_url host: 'ref.st',
                                                         protocol: :https,
                                                         url: encoded.token,
                                                         key: encoded.key
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
