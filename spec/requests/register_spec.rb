require 'rails_helper'

describe 'register' do
  let(:params) { {format: 'html'} }

  context 'GET /register' do
    before(:each) do
      get '/register', params: params
    end

    it 'returns 200' do
      expect(response).to be_successful
    end
  end
end