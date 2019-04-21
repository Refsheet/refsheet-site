# == Schema Information
#
# Table name: notifications
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  character_id        :integer
#  sender_user_id      :integer
#  sender_character_id :integer
#  type                :string
#  actionable_id       :integer
#  actionable_type     :string
#  read_at             :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  guid                :string
#
# Indexes
#
#  index_notifications_on_character_id  (character_id)
#  index_notifications_on_guid          (guid)
#  index_notifications_on_type          (type)
#  index_notifications_on_user_id       (user_id)
#

require 'rails_helper'


describe Account::NotificationsController, type: :controller do
  render_views

  let(:user) { create :admin }

  subject { response }

  before do
    sign_in user
  end

  context 'with notifications' do
    let!(:forum_post) { create :forum_post, content: "Hey, @#{user.username}!" }

    it { expect(user.notifications).to have_at_least(1).items }

    describe 'GET #index' do
      before { get :index, format: :json }

      it { is_expected.to have_http_status :ok }

      it 'fetches data' do
        data = JSON.parse(response.body)
        expect(data.keys).to include "notifications"

        notification = data["notifications"].select { |n| n['actionable']['id'] == forum_post.guid }.first
        expect(notification).to_not be_nil
        expect(notification['title']).to match /mentioned you/
      end
    end
  end
end
