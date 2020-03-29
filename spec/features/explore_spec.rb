require 'rails_helper'

feature 'Explore Images', js: true do
  let(:params) { {} }
  let!(:image) { create :image, hidden: true }
  let(:user) { image.character.user }

  before(:each) do
    sign_in user if user
    visit explore_path(params)
  end

  it 'renders' do
    expect(page).to have_content "Explore Images"
    expect(page).to have_content "RECENT"
    expect(page).to have_content "POPULAR"
    expect(page).to have_content "FAVORITES"
  end

  it 'shows image' do
    expect(page).to have_content image.caption
  end

  context 'when signed out' do
    let(:user) { nil }

    it 'renders' do
      expect(page).to have_content "Explore Images"
      expect(page).to have_content "RECENT"
      expect(page).to have_content "POPULAR"
      expect(page).to have_no_content "FAVORITES"
    end

    it 'shows nothing' do
      expect(Image.count).to eq 1
      expect(page).to have_content "Nothing to show here"
    end
  end
end