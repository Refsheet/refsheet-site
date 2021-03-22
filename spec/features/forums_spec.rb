require 'rails_helper'

feature 'Forums', js: true do
  let(:user) { nil }
  let!(:forum) { create :forum, name: 'Support Forum' }
  let!(:post) { create :forum_discussion, topic: 'Support Topic', forum: forum }

  before(:each) {
    sign_in user
  }

  describe 'V2' do

  end
end
