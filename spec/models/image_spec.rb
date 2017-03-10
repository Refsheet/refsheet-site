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
#

require 'rails_helper'

describe Image, type: :model do
  describe '#source_url_display' do
    let(:url) { 'https://com.example.net/images/foo/bar?image=baz' }
    let(:image) { build :image, source_url: url }
    subject { image.source_url_display }

    it { is_expected.to eq 'com.example.net/.../bar' }

    context 'when simple' do
      let(:url) { 'http://example.net/imageId' }
      it { is_expected.to eq 'example.net/imageId' }
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
    i1 = create :image, character: ch
    i2 = create :image, nsfw: true, character: ch

    expect(ch.images).to include(i1)
    expect(ch.images).to_not include(i2)
    expect(Image.all).to_not include(i2)
    expect(Image.with_nsfw).to include(i2)

    Image.with_nsfw do
      expect(ch.images.count).to eq 2
    end

    expect(ch.images.count).to eq 1
  end
end
