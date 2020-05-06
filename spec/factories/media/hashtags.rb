# == Schema Information
#
# Table name: media_hashtags
#
#  id         :integer          not null, primary key
#  tag        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_media_hashtags_on_lower_tag  (lower((tag)::text) varchar_pattern_ops)
#

FactoryBot.define do
  factory :media_hashtag, class: 'Media::Hashtag' do
    tag { "MyString" }
  end
end
