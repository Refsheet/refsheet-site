require 'rails_helper'

describe SessionController do
  let(:user) { create :user, password: 'fishsticks' }
  let(:user_params) {{ user: { username: user.username, password: 'fishsticks' }}}

  describe 'Persistence' do
    it 'signs in without remembering' do
      post :create, params: user_params.merge(remember: false)
      expect(response).to be_successful
      expect(assigns(:current_user)).to eq user
      expect(cookies.signed[UserSession::COOKIE_USER_ID_NAME]).to eq user.id
      expect(cookies.signed[UserSession::COOKIE_SESSION_ID_NAME]).to eq nil
    end

    it 'signs in with remembering' do
      post :create, params: user_params.merge(remember: true)
      expect(response).to be_successful
      expect(assigns(:current_user)).to eq user

      session = user.sessions.first
      expect(cookies.signed[UserSession::COOKIE_USER_ID_NAME]).to eq user.id
      expect(cookies.signed[UserSession::COOKIE_SESSION_ID_NAME]).to eq session.session_guid
    end
  end
end