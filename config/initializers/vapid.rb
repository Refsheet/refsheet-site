Rails.application.configure do
  Rails.configuration.x.vapid = HashWithIndifferentAccess.new config_for :vapid
end
