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

class Feedback::Reply < ApplicationRecord
  belongs_to :feedback
  belongs_to :user

  validates_presence_of :feedback
  validates_presence_of :user
  validates_presence_of :comment

  after_create :send_email_notice

  private

  def send_email_notice
    return unless self.feedback.user.present?
    FeedbackMailer.reply(self.id).deliver_now
  end
end
