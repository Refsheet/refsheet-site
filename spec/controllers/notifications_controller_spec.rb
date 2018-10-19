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
