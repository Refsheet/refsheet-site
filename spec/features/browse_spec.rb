require 'rails_helper'

feature 'Browse', js: true do
  let(:params) { {} }
  let!(:character) { create :character, hidden: true }
  let(:user) { character.user }

  before(:each) do
    sign_in user if user
    visit browse_path(params)
  end

  it 'renders' do
    expect(page).to have_content "Exactly 1 result"
  end

  context 'when signed out' do
    let(:user) { nil }

    it 'renders' do
      expect(Character.count).to eq 1
      expect(page).to have_content "Exactly 0 results"
    end
  end
end