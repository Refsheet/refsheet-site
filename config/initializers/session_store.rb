# Be sure to restart your server when you modify this file.

if Rails.env.production?
  domain = '.refsheet.net'
  key = "_rsts"
else
  domain = nil
  key = "_rsts_" + Rails.env
end

Rails.configuration.x.cookies = {
    domain: domain
}

Rails.application.config.session_store(
    :cookie_store,
    key: key,
    domain: domain
)
