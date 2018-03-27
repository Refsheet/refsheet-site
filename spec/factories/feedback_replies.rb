# == Schema Information
#
# Table name: feedback_replies
#
#  id           :integer          not null, primary key
#  feedback_id  :integer
#  user_id      :integer
#  comment      :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  freshdesk_id :string
#
# Indexes
#
#  index_feedback_replies_on_feedback_id  (feedback_id)
#  index_feedback_replies_on_user_id      (user_id)
#

FactoryGirl.define do
  factory :feedback_reply, class: 'Feedback::Reply' do
    feedback ""
    user ""
    comment "MyText"
  end
end
