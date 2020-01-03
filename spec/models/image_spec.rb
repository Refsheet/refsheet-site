# == Schema Information
#
# Table name: images
#
#  id                      :integer          not null, primary key
#  character_id            :integer
#  artist_id               :integer
#  caption                 :string
#  source_url              :string
#  image_file_name         :string
#  image_content_type      :string
#  image_file_size         :bigint(8)
#  image_updated_at        :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  row_order               :integer
#  guid                    :string
#  gravity                 :string
#  nsfw                    :boolean
#  hidden                  :boolean          default(FALSE)
#  gallery_id              :integer
#  deleted_at              :datetime
#  title                   :string
#  background_color        :string
#  comments_count          :integer
#  favorites_count         :integer
#  image_meta              :text
#  image_processing        :boolean          default(FALSE)
#  image_direct_upload_url :string
#  watermark               :boolean
#  custom_watermark_id     :integer
#  annotation              :boolean
#  custom_annotation       :string
#  image_phash             :bit(64)
#
# Indexes
#
#  index_images_on_custom_watermark_id  (custom_watermark_id)
#  index_images_on_guid                 (guid)
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
              :caption,
              :character,
              :background_color
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

  it 'does a bad with background_image' do
    image = create :image
    image.update_column :background_color, 'sadflaksdfja43565'
    image.reload
    image.source_url = 'https://foo.com'
    expect(image).to be_valid
    image.background_color = 'asdfasdfa'
    expect(image).to_not be_valid
    image.background_color = '#cbe1f1'
    expect(image).to be_valid
  end

  it 'does not validate color scheme fallthrough' do
    image = create :image
    image.update_column :background_color, 'a'
    image.reload
    image.background_color = nil
    image.character.color_scheme = create :color_scheme
    image.character.color_scheme.color_data['image-background'] = 'asdfasdfa92345'

    expect(image).to be_valid
    expect(image).to have(0).errors_on :background_color
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

  it 'has_markdown_field :caption' do
    i = build :image, caption: nil
    expect { i.caption_html }.to_not raise_error
    expect(i.caption_html).to be_nil
  end

  it 'schedules phash job', paperclip: true do
    skip("This job queues later in the process.")
    a = ActiveJob::Base.queue_adapter = :test

    expect {
      image = create :image, image: asset('fox.jpg')
    }.to enqueue_job(ImagePhashJob)

    ActiveJob::Base.queue_adapter = a
  end

  # TODO: Re-enable when we have a hamming calculation ready for our Docker image / Google Cloud SQL
  xdescribe ".similar_to", paperclip: true do
    let!(:a) { create :image, image: asset('fox.jpg') }
    let!(:b) { create :image, image: asset('fox.jpg') }

    before {
      DelayedPaperclip::ProcessJob.perform_now('Image', a.id, 'image')
      DelayedPaperclip::ProcessJob.perform_now('Image', b.id, 'image')

      ImagePhashJob.perform_now(a)
      ImagePhashJob.perform_now(b)
    }

    it 'does not include self in results' do
      expect(Image.similar_to(a)).to_not include a
    end

    it 'includes other similar images' do
      expect(Image.similar_to(a)).to include b
    end
  end

  # it 'watermarks', paperclip: true do
  #   image = create :image, image: asset('fox.jpg'), watermark: true, annotation: false
  #   wait_until { Image.find(image.id).processed? }
  #   url = "public" + image.reload.image.url(:medium).gsub(/\?.*$/, '')
  #   puts url
  #   # launch = %x{launchy #{url}}
  #   # expect(launch).to eq ""
  #   expect(image).to be_processed
  # end

  describe 'reprocess triggers' do
    it 'does not reprocess on normal change', paperclip: true do
      image = create :image, image: asset('fox.jpg')
      expect(image).to receive(:contemplate_reprocessing).and_call_original
      expect(image.image).to_not receive(:reprocess!)
      image.update_attributes(caption: 'bleh')
    end

    it 'triggers reprocess on gravity change', paperclip: true do
      image = create :image, image: asset('fox.jpg')
      expect(image).to receive(:contemplate_reprocessing).and_call_original
      expect(image.image).to receive(:reprocess!)
      image.update_attributes(gravity: 'South')
    end

    it 'triggers reprocess on watermark change', paperclip: true do
      image = create :image, image: asset('fox.jpg')
      expect(image).to receive(:contemplate_reprocessing).and_call_original
      expect(image.image).to receive(:reprocess!)
      image.update_attributes(watermark: true)
    end

    it 'validates gravity' do
      image = build :image, gravity: 'Newst'
      expect(image).to_not be_valid
      expect(image).to have(1).errors_on(:gravity)
    end

    it 'does not log activity after reprocess', paperclip: true do
      image = create :image, image: asset('fox.jpg')
      expect(image).to be_valid

      expect(image).to receive(:log_activity).exactly(2).times.and_call_original
      image.send(:delayed_complete)

      expect {
        image.update_attributes(gravity: 'South')
        image.send(:delayed_complete)
      }.to_not change { Activity.count }
    end
  end

  describe '#hashtags' do
    it 'syncs hashtags' do
      image = create :image, caption: "This is #so #cool!"
      image.reload
      expect(image).to have_exactly(2).hashtags
      expect(image.hashtags.first.tag).to eq 'so'
    end

    it 'has unique hashtags' do
      image = create :image, caption: "This #hashtag is the #coolest #hashtag"
      image.reload
      expect(image).to have_exactly(2).hashtags
      expect(image.hashtags.first.tag).to eq 'hashtag'
      expect(image.hashtags.second.tag).to eq 'coolest'
    end

    it 'has unique hashtags with mixed case' do
      image = create :image, caption: "THIS IS #AMAZING! (Ruby Rose says #amazing a lot)."
      image.reload
      expect(image).to have_exactly(1).hashtags
      expect(image.hashtags.first.tag).to eq 'amazing'
    end

    it 'handles nil captions' do
      image = create :image, caption: nil
      image.reload
      expect(image).to have_exactly(0).hashtags
    end

    it 'clears hashtags' do
      image = create :image, caption: '#one #two'
      image.reload
      expect(image).to have_exactly(2).hashtags
      expect(image.hashtags.first.tag).to eq 'one'

      image.update_attributes(caption: '#three')
      image.reload
      expect(image).to have_exactly(1).hashtags
      expect(image.hashtags.first.tag).to eq 'three'
    end

    it 'clears hashtags when nil' do
      image = create :image, caption: '#one #two'
      image.reload
      expect(image).to have_exactly(2).hashtags
      expect(image.hashtags.first.tag).to eq 'one'

      image.update_attributes(caption: nil)
      image.reload
      expect(image).to have_exactly(0).hashtags
    end
  end
end
