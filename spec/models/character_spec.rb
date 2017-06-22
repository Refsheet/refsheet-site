# == Schema Information
#
# Table name: characters
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  name              :string
#  slug              :string
#  shortcode         :string
#  profile           :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  gender            :string
#  species           :string
#  height            :string
#  weight            :string
#  body_type         :string
#  personality       :string
#  special_notes     :text
#  featured_image_id :integer
#  profile_image_id  :integer
#  likes             :text
#  dislikes          :text
#  color_scheme_id   :integer
#  nsfw              :boolean
#  hidden            :boolean
#  secret            :boolean
#  row_order         :integer
#

require 'rails_helper'

describe Character, type: :model do
  it_is_expected_to(
    belong_to: [
      :user,
      :color_scheme,
      :featured_image,
      :profile_image
    ],
    have_many: [
      :swatches,
      :images,
      :transfers
    ],
    validate_presence_of: [
      :user,
      :user,
      :name,
      :name
    ]
  )

  it 'scopes slugs right' do
    u1 = create :user
    u2 = create :user
    c1 = create :character, slug: 'fuubar', user: u1
    c2 = build :character, slug: 'fuubar', user: u2

    expect(c1.user_id).to_not eq c2.user_id
    expect(c2).to be_valid
  end

  it 'transfers a character to registered user' do
    old_user = create :user
    new_user = create :user
    character = create :character, user: old_user

    character.transfer_to_user = new_user.username
    character.save!

    expect(character.pending_transfer).to_not be_nil
    expect(old_user.transfers_out.pending).to have(1).items
    expect(new_user.transfers_in.pending).to have(1).items

    new_user.transfers_in.first.claim!
    expect(character.reload.user).to eq new_user
  end

  it 'transfers a character to new user' do
    character = create :character

    character.transfer_to_user = 'FOO@bax.net'
    character.save!

    expect(character.pending_transfer).to_not be_nil
    expect(character.pending_transfer.invitation).to_not be_nil

    new_user = create :user, :confirmed, email: 'foo@bax.net'
    expect(new_user.invitation).to be_claimed
    expect(new_user.transfers_in.pending).to have(1).items

    new_user.transfers_in.pending.first.claim!
    expect(character.reload.user).to eq new_user
  end

  describe '#featured_image' do
    let(:image) { create :image }
    let(:character) { build :character, featured_image: image }
    subject { character }

    it { is_expected.to be_valid }

    context 'when nsfw' do
      let(:image) { create :image, :nsfw }
      it { is_expected.to_not be_valid }
      it { is_expected.to have(1).errors_on :featured_image }
    end

    context 'when nil' do
      let(:image) { nil }
      it { is_expected.to be_valid }
    end

    context 'after flag' do
      before do
        character.save
        image.update_attributes(nsfw: true)
        character.reload
      end

      its(:featured_image) { is_expected.to be_nil }
    end
  end

  describe '#profile_image' do
    let(:image) { create :image }
    let(:character) { build :character, profile_image: image }
    subject { character }

    it { is_expected.to be_valid }

    context 'when nsfw' do
      let(:image) { create :image, :nsfw }
      it { is_expected.to_not be_valid }
      it { is_expected.to have(1).errors_on :profile_image }
    end

    context 'when nil' do
      let(:image) { nil }
      it { is_expected.to be_valid }
    end

    context 'after flag' do
      before do
        character.save
        image.update_attributes(nsfw: true)
        character.reload
      end

      its(:profile_image) { is_expected.to_not eq image }
    end
  end

  it 'caches character group counter' do
    user = create :user
    group = create :character_group, user: user, name: 'Lol'
    c1 = create :character, user: user
    c2 = create :character, :hidden, user: user
    group.characters << c1
    group.characters << c2
    group.reload

    expect(group.characters.count).to eq 2
    expect(group.characters_count).to eq 2
    expect(group.visible_characters_count).to eq 1
    expect(group.hidden_characters_count).to eq 1

    c2.destroy
    group.reload
    expect(group.characters_count).to eq 1

    c3 = create :character, user: user
    c3.character_groups << group

    group.reload
    expect(group.characters_count).to eq 2
    expect(group.visible_characters_count).to eq 2
    expect(group.hidden_characters_count).to eq 0
  end
end
