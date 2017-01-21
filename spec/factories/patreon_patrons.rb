# == Schema Information
#
# Table name: patreon_patrons
#
#  id           :integer          not null, primary key
#  patreon_id   :string
#  email        :string
#  full_name    :string
#  image_url    :string
#  is_deleted   :boolean
#  is_nuked     :boolean
#  is_suspended :boolean
#  status       :string
#  thumb_url    :string
#  twitch       :string
#  twitter      :string
#  youtube      :string
#  vanity       :string
#  url          :string
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :patreon_patron, class: 'Patreon::Patron' do
    patreon_id "MyString"
    email "MyString"
    full_name "MyString"
    image_url "MyString"
    is_deleted false
    is_nuked false
    is_suspended false
    status "MyString"
    thumb_url "MyString"
    twitch "MyString"
    twitter "MyString"
    youtube "MyString"
    vanity "MyString"
    url "MyString"
    user_id 1
  end
end
