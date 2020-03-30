require 'rails_helper'

feature 'Forums', js: true do
  let(:user) { nil }
  let!(:forum) { create :forum, name: 'Fishstickers' }
  let!(:post) { create :forum_discussion, topic: 'Test Me', forum: forum }

  before(:each) {
    sign_in user
  }

  context 'logged out' do
    before(:each) do
      post
      visit forum_path forum
    end

    scenario 'user visits when logged out' do
      expect(page).to have_content 'Fishstickers'
    end

    scenario 'user sees in listing' do
      expect(page).to have_content 'Test Me'
    end
  end

  describe 'V1' do
    describe 'forum list view' do
      before(:each) do
        visit "/forums"
      end

      scenario 'renders without error' do
        expect(page).to have_content 'Discuss & Socialize'
        expect(page).to have_content 'Fishstickers'
      end
    end

    describe 'forum show' do
      before(:each) do
        post
        visit forum_path forum
      end

      scenario 'user visits when logged out' do
        expect(page).to have_content 'Fishstickers'
      end

      scenario 'user sees in listing' do
        expect(page).to have_content 'Test Me'
      end

      context 'logged in' do

      end
    end
  end
end
