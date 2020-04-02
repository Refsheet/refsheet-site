require 'rails_helper'

feature 'Characters / Rich Text', js: true do
  let(:character) { create :character,
                           name: "RichText Test Char",
                           special_notes: "Notes are special",
                           profile: "I like cats.",
                           likes: "cats",
                           dislikes: "not cats",
                           version: 1 }

  let(:user) { character.user }

  before(:each) do
    sign_in user
    visit "/#{character.user.username}/#{character.slug}"
    expect(page).to have_content character.name
  end

  context "signed out" do
    let(:user) { nil }

    # no edit button on any field
    describe "Important Notes" do
      it 'does not show edit button' do
        within ".important-notes" do
          expect(page).to have_no_css("[data-testid=\"rt-edit\"]")
        end
      end
    end

    describe "About" do
      it 'does not show edit button' do
        within "#profile_about" do
          expect(page).to have_no_css("[data-testid=\"rt-edit\"]")
        end
      end
    end
  end

  describe "Important Notes" do
    it 'shows edit button' do
      within ".important-notes" do
        expect(page).to have_css("[data-testid=\"rt-edit\"]")
      end
    end

    it 'toggles edit' do
      within '.important-notes' do
        find("[data-testid=\"rt-edit\"]").click
        expect(page).to have_content "SAVE"
        find("[data-testid=\"rt-cancel\"]").click
        expect(page).to have_no_content "SAVE"
      end
    end

    scenario "user updates field" do
      within '.important-notes' do
        find_testid("rt-edit").click
        expect(page).to have_content "SAVE"
        find_testid("text-area").fill_in with: "> Sample Text"
        find_testid("rt-save").click
        expect_no_testid("rt-save")
        expect(page).to have_css("blockquote")

        within 'blockquote' do
          expect(page).to have_content "Sample Text"
        end

        expect(character.reload.special_notes).to eq "> Sample Text"
      end
    end
  end

  describe "About" do
    it 'shows edit button' do
      within "#profile_about" do
        expect_testid("rt-edit")
      end
    end

    scenario "user updates field" do
      within '#profile_about' do
        find_testid("rt-edit").click
        expect(page).to have_content "SAVE"
        find_testid("text-area").fill_in with: "> Sample Text"
        find_testid("rt-save").click
        expect_no_testid("rt-save")
        expect(page).to have_css("blockquote")

        within 'blockquote' do
          expect(page).to have_content "Sample Text"
        end

        expect(character.reload.profile).to eq "> Sample Text"
      end
    end
  end

  describe "Likes / Dislikes" do
    scenario "user updates field" do
      within '#profile_likes' do
        find_testid("rt-edit").click
        expect(page).to have_content "SAVE"
        find_testid("text-area").fill_in with: "> Sample Text"
        find_testid("rt-save").click
        expect_no_testid("rt-save")
        expect(page).to have_css("blockquote")

        within 'blockquote' do
          expect(page).to have_content "Sample Text"
        end

        expect(character.reload.likes).to eq "> Sample Text"
      end
    end
  end
end