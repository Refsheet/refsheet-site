require 'rails_helper'

describe Mutations::SessionMutations do
  let!(:user) { create :user, username: 'jdoe', password: 'fishsticks' }

  let(:session) {{
      sessionId: 'abc',
      currentUser: user
  }}

  let(:sign_in) { double('SignInMethod') }

  let(:context) {{
      session: double(call: double(:[] => nil)),
      cookies: double(call: double(signed: double(:[] => nil))),
      sign_in: sign_in
  }}

  describe 'createSession' do
    let(:query) { <<-GRAPHQL }
      mutation {
        createSession(username: "jdoe", password: "fishsticks", remember: false) {
          currentUser { username }
          sessionId
        }
      }
    GRAPHQL

    let(:result) { graphql_query query, context: context }

    subject { result }

    it 'authenticates' do
      expect(sign_in).to receive(:call).with(user, remember: false).and_return(true)
      expect(subject[:errors]).to be_nil
      expect(subject[:data][:createSession]).to include(:currentUser)
    end

    # context 'when authorized' do
    #   let(:context) {{ current_user: user }}
    #
    #   it 'updates name' do
    #     expect(subject[:errors]).to be_nil
    #     expect(subject[:data][:updateSession][:name]).to eq "John Doe"
    #     expect(character.reload.name).to eq "John Doe"
    #   end
    # end
  end
end
