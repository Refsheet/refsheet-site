# == Schema Information
#
# Table name: images
#
#  id                 :integer          not null, primary key
#  character_id       :integer
#  artist_id          :integer
#  caption            :string
#  source_url         :string
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  row_order          :integer
#  guid               :string
#  gravity            :string
#  nsfw               :boolean
#  hidden             :boolean
#  gallery_id         :integer
#  deleted_at         :datetime
#  title              :string
#  background_color   :string
#

require 'rails_helper'

describe Image, type: :model do
  it_is_expected_to(
      belong_to: :character,
      have_one: :user,
      have_many: [
          :favorites
      ],
      validate_presence_of: :image,
      act_as_paranoid: true,
      have_db_column: [
          :guid, :gravity, :nsfw, :hidden
      ],
      respond_to: [
          :source_url_display,
          :regenerate_thumbnail!,
          :clean_up_character,
          :managed_by?
      ],
      not: {
          belong_to: [
              :gallery, :artist
          ],
          validate_presence_of: [
              :caption, :character
          ]
      }
  )

  describe '#source_url_display' do
    let(:url) { 'https://com.example.net/images/foo/bar?image=baz' }
    let(:image) { build :image, source_url: url }
    subject { image.source_url_display }

    it { is_expected.to eq 'com.example.net/.../bar' }

    context 'when simple' do
      let(:url) { 'http://example.net/imageId' }
      it { is_expected.to eq 'example.net/imageId' }
    end

    context 'missing protocol' do
      let(:url) { 'example.net/images/foo' }
      it { is_expected.to eq 'example.net/.../foo' }

      context 'missing path' do
        let(:url) { 'example.foo.net' }
        it { is_expected.to eq 'example.foo.net' }
      end
    end
  end

  it 'cleans featured image' do
    character = create :character
    image = create :image, character: character

    character.update_attributes featured_image: image
    expect(character.reload.featured_image_id).to eq image.id
    image.destroy

    expect(character.reload.featured_image_id).to be_nil
  end

  it 'scopes sfw' do
    ch = create :character
    create :image, character: ch
    i2 = create :image, nsfw: true, character: ch

    expect(Image.all).to include(i2)
    expect(Image.sfw).to_not include(i2)
  end
end
