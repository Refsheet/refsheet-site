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
#  image_file_size         :bigint
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
#  index_images_on_character_id         (character_id)
#  index_images_on_custom_watermark_id  (custom_watermark_id)
#  index_images_on_deleted_at           (deleted_at)
#  index_images_on_gallery_id           (gallery_id)
#  index_images_on_guid                 (guid)
#  index_images_on_hidden               (hidden)
#  index_images_on_image_processing     (image_processing)
#  index_images_on_row_order            (row_order)
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

    character.update featured_image: image
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

  describe ".similar_to", paperclip: true do
    let!(:a) { create :image, image: asset('fox.jpg') }
    let!(:b) { create :image, image: asset('fox.jpg') }
    let!(:c) { create :image, image: asset("advertisement_test.png") }

    before {
      DelayedPaperclip::ProcessJob.perform_now('Image', a.id, 'image')
      DelayedPaperclip::ProcessJob.perform_now('Image', b.id, 'image')
      DelayedPaperclip::ProcessJob.perform_now('Image', c.id, 'image')

      ImagePhashJob.perform_now(a)
      ImagePhashJob.perform_now(b)
      ImagePhashJob.perform_now(c)
    }

    it 'does not include self in results' do
      expect(Image.similar_to(a)).to_not include a
    end

    it 'includes other similar images' do
      expect(Image.similar_to(a)).to include b
    end

    it 'excludes dissimilar images' do
      expect(Image.similar_to(a)).to_not include c
    end

    it 'includes phash_distance' do
      q = Image.similar_to(a)
      expect(q.first.phash_distance).to eq 0
    end

    it 'matches very distant images if required' do
      q = Image.similar_to(c, distance: 64)
      expect(q).to include a
      expect(q.first.phash_distance).to eq 42
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
      image.update(caption: 'bleh')
    end

    it 'triggers reprocess on gravity change', paperclip: true do
      image = create :image, image: asset('fox.jpg')
      image.image_processing = false
      expect(image).to receive(:contemplate_reprocessing).and_call_original
      expect { image.update(gravity: 'South') }.to change { image.image_processing? }
    end

    it 'triggers reprocess on watermark change', paperclip: true do
      image = create :image, image: asset('fox.jpg')
      image.image_processing = false
      expect(image).to receive(:contemplate_reprocessing).and_call_original
      expect { image.update(watermark: true) }.to change { image.image_processing? }
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

      expect_any_instance_of(Image).to receive(:contemplate_reprocessing)

      expect {
        image.update(gravity: 'South')
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

      image.update(caption: '#three')
      image.reload
      expect(image).to have_exactly(1).hashtags
      expect(image.hashtags.first.tag).to eq 'three'
    end

    it 'clears hashtags when nil' do
      image = create :image, caption: '#one #two'
      image.reload
      expect(image).to have_exactly(2).hashtags
      expect(image.hashtags.first.tag).to eq 'one'

      image.update(caption: nil)
      image.reload
      expect(image).to have_exactly(0).hashtags
    end
  end
end
