require 'rails_helper'

describe Webhooks::PatreonController, type: :request do
  let(:headers) {{
      'X-Patreon-Event' => 'test',
      'X-Patreon-Signature' => 'not-a-signature'
  }}

  describe '#create' do
    it 'handles patron:create' do
      payload = { data: {} }

      post '/webhooks/patreon', payload, headers
      expect(response).to have_http_status :ok
    end

    it 'handles patron:update' do
      payload = { data: {} }

      post '/webhooks/patreon', payload, headers
      expect(response).to have_http_status :ok
    end

    it 'handles patron:delete' do
      payload = { data: {} }

      post '/webhooks/patreon', payload, headers
      expect(response).to have_http_status :ok
    end
  end
end
