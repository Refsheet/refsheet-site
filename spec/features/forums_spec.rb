require 'rails_helper'

feature 'Forums', js: true do
  let(:user) { nil }
  let!(:forum) { create :forum, name: 'Support Forum' }
  let!(:post) { create :forum_discussion, topic: 'Support Topic', forum: forum }

  before(:each) {
    sign_in user
  }

  describe 'V1' do
    describe 'forum list view' do
      before(:each) do
        visit "/forums"
      end

      it 'renders without error' do
        expect(page).to have_content 'Discuss & Socialize'
        expect(page).to have_content 'Support Forum'
      end
    end

    describe 'forum show' do
      before(:each) do
        post
        visit "/forums/#{forum.slug}"
      end

      it "renders without error" do
        expect(page).to have_content 'Support Topic'
        expect(page).to have_content 'Support Forum'
      end

      it "doesn't have FAB" do
        expect(page).to have_no_selector('.fixed-action-btn')
      end

      context 'logged in' do
        let(:user) { create :user }

        it "has FAB" do
          expect(page).to have_selector('.fixed-action-btn')
          page.find('.fixed-action-btn').click
          expect(page).to have_content("New Thread")
        end

        scenario 'user creates new post' do
          count = Forum::Discussion.count
          page.find('.fixed-action-btn').find('a').click
          expect(page).to have_content("New Thread")
          fill_in(:thread_topic, with: "This is a new thread")
          fill_in(:thread_content, with: "Hello, how are you?")
          click_button(:thread_submit)
          expect(page).to have_content("Thread created")
          expect(page).to have_no_content("New Thread")
          expect(page).to have_content("This is a new thread")
          expect(page).to have_current_path("/forums/#{forum.slug}/this-is-a-new-thread")
          expect(Forum::Discussion.count).to eq count + 1
        end
      end
    end
  end
end
