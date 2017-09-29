# == Schema Information
#
# Table name: feedback_replies
#
#  id          :integer          not null, primary key
#  feedback_id :integer
#  user_id     :integer
#  comment     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Feedback::Reply, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
