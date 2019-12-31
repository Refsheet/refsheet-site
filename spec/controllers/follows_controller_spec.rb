require 'rails_helper'

describe FollowsController, type: :controller do
  let(:user) { create :user }

  it 'has public show' do
    get :show, params: { user_id: user.username }
    expect(response).to have_http_status :ok
  end

  it 'has private suggested' do
    get :suggested
    expect(response).to have_http_status :unauthorized
  end

  context 'when signed in' do
    before { sign_in user }

    it 'shows suggested' do
      get :suggested
      expect(response).to have_http_status :ok
    end

    it 'limits' do
      get :suggested, params: { limit: '6' }
      expect(response).to have_http_status :ok
    end
  end
end
