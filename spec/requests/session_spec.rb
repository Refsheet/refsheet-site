require 'rails_helper'

describe 'Session' do
  let(:user) { create :user, password: 'fishsticks' }
  let(:user_params) {{ user: { username: user.username, password: 'fishsticks' }}}

  context 'POST /session' do
    it 'stores short user cookie when not remembering' do
      post "/session", params: user_params.merge(remember: false)
      expect(response).to be_successful
      cookie = cookies.get_cookie("user_id")
      expect(cookie.value).to_not match /^\d+$/
      expect(cookie.expires).to_not be_present
    end

    it 'stores long user cookie when remembering' do
      post "/session", params: user_params.merge(remember: true)
      expect(response).to be_successful
      cookie = cookies.get_cookie("user_id")
      expect(cookie.value).to_not match /^\d+$/
      expect(cookie.expires).to be_present
      expect(cookie.expires).to be > 10.years.from_now

      Timecop.travel(1.year.from_now) do
        future_cookie = cookies.get_cookie("user_id")
        expect(future_cookie.value).to eq cookie.value
      end
    end
  end

  class Rack::Test::CookieJar
    def get_cookie(name)
      self.hash_for(nil).fetch(name, nil)
    end
  end
end