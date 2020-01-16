require 'rails_helper'

describe 'Session' do
  let(:user) { create :user, password: 'fishsticks' }
  let(:user_params) {{ user: { username: user.username, password: 'fishsticks' }}}
  let(:json) { JSON.parse(response.body) }

  context 'POST /session' do
    context "remember: false" do
      before(:each) do
        post "/session", params: user_params.merge(remember: false)
        expect(response).to be_successful
      end

      it 'stores short user cookie' do
        cookie = cookies.get_cookie(UserSession::COOKIE_USER_ID_NAME)
        expect(cookie.value).to_not match /^\d+$/
        expect(cookie.expires).to_not be_present

        Timecop.travel(1.year.from_now) do
          cookies.expire_all!
          future_cookie = cookies.get_cookie(UserSession::COOKIE_USER_ID_NAME)
          expect(future_cookie).to be_nil
        end
      end

      it 'forgot the user' do
        Timecop.travel(1.year.from_now) do
          cookies.expire_all!
          get "/session"
          expect(json).to include 'current_user'
          expect(json['current_user']).to be_nil
        end
      end
    end

    context "remember: true" do
      before(:each) do
        post "/session", params: user_params.merge(remember: true)
        expect(response).to be_successful
      end

      it 'stores long user cookie' do
        cookie = cookies.get_cookie(UserSession::COOKIE_USER_ID_NAME)
        expect(cookie.value).to_not match /^\d+$/
        expect(cookie.expires).to be_present
        expect(cookie.expires).to be > 10.years.from_now

        Timecop.travel(1.year.from_now) do
          cookies.expire_all!
          future_cookie = cookies.get_cookie(UserSession::COOKIE_USER_ID_NAME)
          expect(future_cookie.value).to eq cookie.value
        end
      end

      it 'signs user back in' do
        Timecop.travel(1.year.from_now) do
          cookies.expire_all!
          get "/session"
          expect(json).to include 'current_user'
          expect(json['current_user']['username']).to eq user.username
        end
      end
    end
  end
end