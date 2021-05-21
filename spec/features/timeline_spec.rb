require 'rails_helper'

feature 'Timeline', js: true do
  let(:params) {{}}
  let(:user) { create :user, :confirmed }

  before(:each) do
    sign_in user if user
    visit root_path(params)
  end

  it 'renders timeline' do
    expect(page).to have_content "ACTIVITY FEED"
  end

  context "when admin" do
    let(:user) { create :admin, :confirmed }

    it 'renders status box' do
      expect(page).to have_content "As: #{user.name}"
    end
  end

  context "when patron" do
    let(:user) { create :patron, :confirmed }

    it 'renders status box' do
      expect(page).to have_content "As: #{user.name}"
    end
  end

  context "when supporter" do
    let(:user) { create :user, :confirmed, support_pledge_amount: 5 }

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

  context 'without confirmation' do
    let(:user) { create :user }

    it 'does not allow status' do
      expect(page).to have_no_content "As: #{user.name}"
      expect(page).to have_content "Your email address is unconfirmed."
    end
  end
end
