require 'rails_helper'

feature 'Timeline', js: true do
  let(:params) {{}}
  let(:user) { create :user }

  before(:each) do
    sign_in user if user
    visit root_path(params)
  end

  it 'renders timeline' do
    expect(page).to have_content "ACTIVITY FEED"
  end

  context "when supporter" do
    let(:user) { create :admin }

    it 'renders status box' do
      expect(page).to have_content "As: #{user.name}"
    end
  end

  context 'when signed out' do
    let(:user) { nil }

    it 'renders homepage' do
      expect(page).to have_content "Your characters, organized."
    end
  end
end