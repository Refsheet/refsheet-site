# == Schema Information
#
# Table name: blocked_users
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  blocked_user_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_blocked_users_on_blocked_user_id  (blocked_user_id)
#  index_blocked_users_on_user_id          (user_id)
#

require 'rails_helper'

RSpec.describe BlockedUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
