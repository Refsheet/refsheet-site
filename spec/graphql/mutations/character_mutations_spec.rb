require 'rails_helper'

describe Mutations::CharacterMutations do
  let(:character) { create :character }
  let(:user) { character.user }
  let(:context) { nil }

  let(:query) { <<-GRAPHQL }
    mutation {
      updateCharacter(id: "#{character.shortcode}", name: "John Doe") {
        name
      }
    }
  GRAPHQL

  let(:result) { graphql_query query, context: context }

  subject { result }

  it 'requires authorization' do
    expect(subject[:errors]).to have_at_least(1).items
    expect(character.reload.name).to_not eq "John Doe"
  end

  context 'when authorized' do
    let(:context) {{ current_user: user }}

    it 'updates name' do
      expect(subject[:errors]).to be_nil
      expect(subject[:data][:updateCharacter][:name]).to eq "John Doe"
      expect(character.reload.name).to eq "John Doe"
    end
  end
end
