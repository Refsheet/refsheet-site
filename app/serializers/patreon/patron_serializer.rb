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
# Indexes
#
#  index_patreon_patrons_on_lower_email      (lower((email)::text) varchar_pattern_ops)
#  index_patreon_patrons_on_patreon_id       (patreon_id)
#  index_patreon_patrons_on_pending_user_id  (pending_user_id)
#  index_patreon_patrons_on_status           (status)
#  index_patreon_patrons_on_user_id          (user_id)
#

class Patreon::PatronSerializer < ActiveModel::Serializer
  attributes :email,
             :full_name,
             :status,
             :thumb_url,
             :username

  def username
    object.user&.username
  end
end
