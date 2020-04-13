require 'rails_helper'

xfeature 'Messages Page', js: true do
  let(:params) { {} }
  let(:user) { create :user }

  before(:each) do
    sign_in user if user
    visit messages_path(params)
  end

  it 'renders' do
    expect(page).to have_content "Messages"
  end

  context 'when signed out' do
    let(:user) { nil }

    it 'renders' do
      expect(page).to have_content "Not authorized"
    end
  end
end