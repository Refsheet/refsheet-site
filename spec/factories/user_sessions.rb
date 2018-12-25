# == Schema Information
#
# Table name: user_sessions
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  ahoy_visit_id        :integer
#  session_guid         :string
#  session_token_digest :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_user_sessions_on_ahoy_visit_id  (ahoy_visit_id)
#  index_user_sessions_on_session_guid   (session_guid)
#  index_user_sessions_on_user_id        (user_id)
#

FactoryBot.define do
  factory :user_session do
    user
  end
end
