require 'rails_helper'

feature 'Characters / Navigation', js: true do
  let(:character_1) { create :character, name: "Nav Test Char 1", version: 1 }
  let(:user) { character_1.user }
  let!(:character_2) { create :character, name: "Nav Test Char 2", version: 1, user: user }
  let!(:v2_char) { create :character, name: "Nav Test V2 Char", version: 2, user: user }

  before(:each) do
    sign_in user
    visit "/#{character_1.user.username}/#{character_1.slug}"
    expect(page).to have_content character_1.name
  end

  scenario "user navigates to user profile" do
    click_testid("user-menu")
    click_testid("user-profile-link")

    within(".sidebar") do
      expect(page).to have_content("NEW CHARACTER")
    end

    within(".user-characters") do
      expect(page).to have_content(character_1.name)
      expect(page).to have_content(character_2.name)
      expect(page).to have_content(v2_char.name)
    end
  end

  scenario "user navigates to another profile" do
    click_testid("user-menu")
    click_testid("user-profile-link")

    within(".user-characters") do
      click_link(character_2.name)
    end

    within(".character-details") do
      expect(page).to have_content(character_2.name)
    end
  end

  scenario "user navigates to a v2 profile" do
    click_testid("user-menu")
    click_testid("user-profile-link")

    within(".user-characters") do
      click_link(v2_char.name)
    end

    within(".character-details") do
      expect(page).to have_content(v2_char.name)
    end
  end
end