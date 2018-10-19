class FeedbackMailer < ApplicationMailer
  def reply(feedback_reply_id)
    @reply = Feedback::Reply.find feedback_reply_id
    @feedback = @reply.feedback
    @user = @feedback.user
    @sender = @reply.user

    @preheader = "#{@sender.name} has replied to your feedback request sent on #{@feedback.created_at.strftime('%b %d, %Y')}"

    mail to: @user.email_to,
         reply_to: @sender.email_to,
         subject: "[Refsheet.net] #{@sender.name} has replied to your feedback request."
  end
end
