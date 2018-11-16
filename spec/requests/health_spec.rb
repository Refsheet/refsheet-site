require 'rails_helper'

describe 'Health Checks' do
  describe '/health' do
    it 'does not track ahoy visit' do
      expect(Ahoy::Visit).to_not receive(:new)
      get '/health'
    end

    it 'returns 200 on success' do
      expect(User).to receive(:count).and_call_original
      get '/health'
      expect(response).to have_http_status :ok
    end

    it 'returns error if DB disconnected' do
      expect(User).to receive(:count).and_raise {
        ActiveRecord::ConnectionNotEstablished.new
      }

      get '/health'
      expect(response).to have_http_status :internal_server_error
    end
  end
end
