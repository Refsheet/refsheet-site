require 'rails_helper'

describe Account::PatronsController do
  let(:user) { create :user }

  before do
    sign_in user
  end

  def lookup(email)
    put :update, params: { patron: { lookup_email: email } }
  end

  describe 'PUT update' do
    it 'does not find patron' do
      lookup 'foo@bar.com'
      expect(response).to have_http_status(:not_found)
    end

    it 'rejects claimed patron' do
      patron = create :patreon_patron

      lookup patron.email
      expect(response).to have_http_status(:bad_request)
    end

    it 'matches a patron' do
      patron = create :patreon_patron, user: nil
      expect(UserMailer).to receive(:patron_link).and_call_original

      lookup patron.email

      expect(response).to have_http_status(:ok)
      expect(patron.reload.pending_user_id).to eq user.id
    end
  end

  def link(email, auth=nil)
    get :link, params: { lookup_email: email, auth: auth }
  end

  def expect_flash(level, message=nil)
    expect(response).to redirect_to account_support_patron_path
    expect(controller).to set_flash[level]
    expect(controller).to set_flash[level].to message if message
  end

  describe 'GET link' do
    it 'does not find patron' do
      link 'foo@bar.com'
      expect_flash :error, /not found/
    end

    it 'does not accept code' do
      patron = create :patreon_patron, user: nil, pending_user_id: user.id
      patron.generate_auth_code!

      link patron.email, 'nacho'
      expect_flash :error, /Invalid auth/
    end

    it 'does not clobber user' do
      patron = create :patreon_patron
      code = patron.generate_auth_code!

      link patron.email, code
      expect_flash :error, /already linked/
    end

    it 'links successfully' do
      patron = create :patreon_patron, user: nil, pending_user_id: user.id
      code = patron.generate_auth_code!

      link patron.email, code
      expect_flash :notice
      expect(patron.reload.user).to eq user
    end
  end
end
