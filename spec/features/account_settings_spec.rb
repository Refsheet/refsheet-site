require 'rails_helper'

feature 'Account Settings', js: true do
  let(:params) { {} }
  let(:user) { create :user }

  before(:each) do
    sign_in user if user
    visit "/account"
  end

  it 'renders' do
    expect(page).to have_content "Delete Account"
  end

  context 'when signed out' do
    let(:user) { nil }

    it 'renders' do
      expect(page).to have_content "Signed out, redirecting..."
    end
  end
end