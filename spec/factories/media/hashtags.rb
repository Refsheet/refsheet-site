# == Schema Information
#
# Table name: media_hashtags
#
#  id         :integer          not null, primary key
#  tag        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :media_hashtag, class: 'Media::Hashtag' do
    tag { "MyString" }
  end
end
