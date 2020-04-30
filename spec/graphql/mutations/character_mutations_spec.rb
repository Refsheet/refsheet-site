require 'rails_helper'

describe Mutations::CharacterMutations do
  let(:character) { create :character, name: "Old Name" }
  let(:user) { character.user }
  let(:context) { nil }

  let(:result) { graphql_query query, context: context }
  subject { result }

  describe 'updateCharacter' do
    let(:new_name) { "John Doe" }

    let(:query) { <<-GRAPHQL }
      mutation {
        updateCharacter(id: "#{character.guid}", name: "#{new_name}") {
          name
        }
      }
    GRAPHQL

    it 'requires authorization' do
      expect(subject[:errors]).to have_at_least(1).items
      expect(character.reload.name).to eq "Old Name"
    end

    context 'when authorized' do
      let(:context) {{ current_user: -> { user } }}

      it 'updates name' do
        expect(subject[:errors]).to be_nil
        expect(subject[:data][:updateCharacter][:name]).to eq "John Doe"
        expect(character.reload.name).to eq "John Doe"
      end

      context 'with invalid name' do
        let(:new_name) { "" }

        it 'returns error' do
          expect(subject[:errors]).to have_at_least(1).items
          expect(character.reload.name).to eq "Old Name"
        end
      end
    end
  end

  describe 'convertCharacter' do
    let(:query) { <<-GRAPHQL }
      mutation {
        convertCharacter(id: "#{character.guid}") {
          id
          version
        }
      }
    GRAPHQL

    it 'requires authorization' do
      expect(subject[:errors]).to have_at_least(1).items
      expect(character.reload.version).to eq 1
    end

    context 'when authorized' do
      let(:context) {{ current_user: -> { user } }}

      it 'updates' do
        expect(subject[:errors]).to be_nil
        expect(subject[:data][:convertCharacter][:version]).to eq 2
        expect(character.reload.version).to eq 2
      end
    end
  end

  describe 'destroyCharacter' do
    let(:confirmation) { character.slug}

    let(:query) { <<-GRAPHQL }
      mutation {
        destroyCharacter(id: "#{character.guid}", confirmation: "#{confirmation}") {
          id
          deleted_at
        }
      }
    GRAPHQL

    it 'requires authorization' do
      expect(subject[:errors]).to have_at_least(1).items
      expect(character.reload.deleted_at).to be_nil
    end

    context 'when authorized' do
      let(:context) {{ current_user: -> { user } }}

      it 'destroys' do
        expect(subject[:errors]).to be_nil
        expect(subject[:data][:destroyCharacter][:deleted_at]).to_not be_nil
        expect(character.reload.deleted_at).to_not be_nil
      end
    end
  end
end
