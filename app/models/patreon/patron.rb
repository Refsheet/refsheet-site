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

class Patreon::Patron < ApplicationRecord
  has_many :pledges, class_name: Patreon::Pledge, foreign_key: :patreon_patron_id
  has_many :rewards, through: :pledges
  belongs_to :user
end
