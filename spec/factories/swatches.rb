# == Schema Information
#
# Table name: swatches
#
#  id           :integer          not null, primary key
#  character_id :integer
#  name         :string
#  color        :string
#  notes        :text
#  row_order    :integer
#  guid         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :swatch do
    character_id 1
    name "MyString"
    color "MyString"
    notes "MyText"
    row_order 1
    guid "MyString"
  end
end
