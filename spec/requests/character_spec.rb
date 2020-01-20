require 'rails_helper'

describe '/characters' do
  let(:user) { create :user, username: 'username' }
  let(:character) { create :character, slug: 'my-oc', user: user }
  let(:path) { "/#{user.username}/#{character.slug}" }
  let(:params) { {format: 'json'} }
  let(:json) { JSON.parse(response.body, symbolize_names: true) }

  context 'GET /:username/:slug' do
    before(:each) do
      get path, params: params
    end

    it 'returns 200' do
      expect(response).to be_successful
    end

    it 'includes basic data' do
      color_data = {
          accent1: anything,
          accent2: anything,
          background: anything,
          border: anything,
          cardBackground: anything,
          cardHeaderBackground: anything,
          imageBackground: anything,
          primary: anything,
          text: anything,
          textLight: anything,
          textMedium: anything,
      }

      character_data = {
          name: character.name,
          species: character.species,
          slug: 'my-oc',
          user_id: 'username',
          user_name: user.name,
          version: 1,
          hidden: false,
          color_scheme: hash_including({
              color_data: hash_including(color_data),
              name: anything,
              user_id: anything,
          }),
      }

      expect(json).to match hash_including(character_data)
    end

    context 'when character does not belong to user' do
      let(:character) { create :character }

      it 'returns 404' do
        expect(response).to be_not_found
      end
    end
  end

  context 'PATCH /users/:username/characters/:slug' do
    let(:active_user) { user }
    let(:path) { "/users/#{user.username}/characters/#{character.slug}" }
    let(:character_data) { { name: 'This is Updated' } }
    let(:payload) { { character: character_data } }

    subject do
      sign_in active_user
      patch path, params: params.merge(payload)
      response
    end

    it 'returns 200' do
      expect(subject).to be_successful
      expect(character.reload.name).to eq 'This is Updated'
    end

    context 'with color data' do
      let(:character_data) {{
          color_scheme_attributes: {
              color_data: {
                  primary: '#abc123'
              }
          }
      }}

      it 'updates colors' do
        expect(subject).to be_successful
        expect(json[:color_scheme][:color_data][:primary]).to eq '#abc123'
        expect(character.reload.color_scheme.get_color(:primary)).to eq '#abc123'
      end
    end

    context 'with invalid color data' do
      let(:character_data) {{
          name: '--updated--',
          color_scheme_attributes: {
              color_data: {
                  primary: 'this is not a color'
              }
          }
      }}

      it 'returns 400' do
        expect(subject).to be_bad_request
      end

      it 'does not create a new color' do
        expect { subject }.to_not change { ColorScheme.count }
        expect(character.color_scheme_id).to be_nil
      end

      it 'does not change character name' do
        expect { subject }.to_not change { character.reload.name }
      end

      it 'shows errors on character' do
        subject
        expect(json).to match hash_including errors: anything
      end
    end

    context 'when wrong user' do
      let(:active_user) { create :user }

      it 'returns 401' do
        expect(subject).to be_unauthorized
        expect(character.reload.name).to_not eq 'This is Updated'
      end
    end

    context 'when admin' do
      let(:active_user) { create :admin }

      # TODO: Allow admins full control??
      xit 'returns 200' do
        expect(subject).to be_successful
        expect(character.reload.name).to eq 'This is Updated'
      end
    end
  end
end