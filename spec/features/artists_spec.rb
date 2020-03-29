require 'rails_helper'

xfeature 'Artists Pages', js: true do
  let(:params) { {} }
  let(:path) { artists_path(params) }
  let(:user) { create :user }
  let!(:artist) { create :artist }

  before(:each) do
    sign_in user if user
    visit path
  end

  it 'renders' do
    expect(page).to have_content "Artists"
    expect(page).to have_content "#{artist.name}"
  end

  context 'when signed out' do
    let(:user) { nil }

    it 'renders' do
      expect(page).to have_content "Artists"
      expect(page).to have_content "#{artist.name}"
    end
  end

  context 'Show' do
    let(:path) { artist_path(artist, params) }

    it 'renders' do
      expect(page).to have_content "#{artist.name}"
      expect(page).to have_content "#{artist.profile}"
    end
  end
end