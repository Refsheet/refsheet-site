# == Schema Information
#
# Table name: characters
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name       :string
#  url        :string
#  shortcode  :string
#  profile    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :character do
    user_id 1
    name "MyString"
    url "MyString"
    shortcode "MyString"
    profile "MyText"
  end
end
