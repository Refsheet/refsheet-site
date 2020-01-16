class Rack::Test::CookieJar
  def get_cookie(name)
    self.hash_for(nil).fetch(name, nil)
  end

  def expire_all!
    self.hash_for(nil).collect do |name, cookie|
      if cookie.expires.nil? or cookie.expires <= Time.zone.now
        self.delete(name)
      end
    end
  end
end