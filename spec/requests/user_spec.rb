require 'rails_helper'

describe 'User Profiles' do
  let(:user) { create :user, :with_characters, :with_character_groups, username: 'username' }
  let(:params) { {format: 'json'} }

  context 'GET /username' do
    before(:each) do
      get '/' + user.username, params: params
    end

    it 'returns 200' do
      expect(response).to be_successful
    end

    it 'does not include email' do
      expect(response.body).to_not include user.email
    end

    context 'when html' do
      let(:params) { { format: 'html' } }
      it { expect(response).to be_successful }
      it { expect(response.body).to include 'og:image' }
    end
  end

  context 'GET /fakeuser' do
    before(:each) do
      get '/fakeuser', params: params
    end

    it 'returns 404' do
      expect(response).to be_not_found
    end
  end
end