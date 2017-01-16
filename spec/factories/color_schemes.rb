# == Schema Information
#
# Table name: color_schemes
#
#  id         :integer          not null, primary key
#  name       :string
#  user_id    :integer
#  color_data :text
#  guid       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :color_scheme do
    name "MyString"
    user_id 1
    color_data "MyText"
  end
end
