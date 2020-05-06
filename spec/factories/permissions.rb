# == Schema Information
#
# Table name: permissions
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  role_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_permissions_on_role_id              (role_id)
#  index_permissions_on_user_id              (user_id)
#  index_permissions_on_user_id_and_role_id  (user_id,role_id)
#

FactoryBot.define do
  factory :permission do
    user
    role
  end
end
