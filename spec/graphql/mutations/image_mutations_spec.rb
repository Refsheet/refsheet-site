require 'rails_helper'

describe Mutations::ImageMutations do
  let(:character) { create :character }
  let(:user) { character.user }
  let(:context) { nil }

  let(:query) { <<-GRAPHQL }
    mutation {
      uploadImage(characterId: "#{character.id}", title: "Image of John Doe", location: "https://test.com/image.png") {
        id title
      }
    }
  GRAPHQL

  let(:result) { graphql_query query, context: context }

  subject { result }

  it 'requires authorization' do
    expect { subject }.to_not change { character.images.count }
    expect(subject[:errors]).to have_at_least(1).items
  end

  context 'when authorized' do
    let(:context) {{ current_user: -> { user } }}

    it 'uploads image' do
      expect { subject }.to change { character.images.count }
      expect(subject[:errors]).to be_nil
      expect(subject[:data][:uploadImage][:title]).to eq "Image of John Doe"
    end
  end
end
