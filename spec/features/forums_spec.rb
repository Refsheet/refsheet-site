require 'rails_helper'

feature 'Forums', js: true do
  let(:forum) { create :forum, name: 'Fishstickers' }
  let!(:post) { create :forum_discussion, topic: 'Test Me', forum: forum }

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
end
