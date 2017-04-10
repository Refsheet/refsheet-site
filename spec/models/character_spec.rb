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
#

require 'rails_helper'

describe Character, type: :model do
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
end
