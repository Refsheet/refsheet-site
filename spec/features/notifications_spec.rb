require 'rails_helper'

feature 'Notifications Page', js: true do
  let(:params) { {} }
  let(:user) { create :user }

  before(:each) do
    sign_in user if user
    visit notifications_path(params)
  end

  it 'renders' do
    expect(page).to have_content "READ ALL"
  end

  context 'when signed out' do
    let(:user) { nil }

    it 'renders' do
      expect(page).to have_content "Not Authorized"
    end
  end
end