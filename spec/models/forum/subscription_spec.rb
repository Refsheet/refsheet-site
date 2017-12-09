# == Schema Information
#
# Table name: forum_subscriptions
#
#  id            :integer          not null, primary key
#  discussion_id :integer
#  user_id       :integer
#  last_read_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_forum_subscriptions_on_discussion_id  (discussion_id)
#  index_forum_subscriptions_on_user_id        (user_id)
#

require 'rails_helper'

RSpec.describe Forum::Subscription, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
