# == Schema Information
#
# Table name: patreon_patrons
#
#  id               :integer          not null, primary key
#  patreon_id       :string
#  email            :string
#  full_name        :string
#  image_url        :string
#  is_deleted       :boolean
#  is_nuked         :boolean
#  is_suspended     :boolean
#  status           :string
#  thumb_url        :string
#  twitch           :string
#  twitter          :string
#  youtube          :string
#  vanity           :string
#  url              :string
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  auth_code_digest :string
#  pending_user_id  :integer
#

FactoryGirl.define do
  factory :patreon_patron, class: 'Patreon::Patron' do
    patreon_id { 'notavalidid' }
    email { Faker::Internet.email }
    full_name { Faker::Name.name }
    user
  end
end
