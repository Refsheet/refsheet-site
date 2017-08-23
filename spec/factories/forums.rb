# == Schema Information
#
# Table name: forums
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  slug        :string
#  locked      :boolean
#  nsfw        :boolean
#  no_rp       :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :forum do
    name "MyString"
    description "MyText"
    slug "MyString"
    locked false
    nsfw false
  end
end
