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
# Indexes
#
#  index_color_schemes_on_guid     (guid)
#  index_color_schemes_on_user_id  (user_id)
#

FactoryBot.define do
  factory :color_scheme do
    color_data {{ 'accent-1' => '#cbe1f1' }}
  end
end
