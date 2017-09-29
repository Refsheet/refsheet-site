class Admin::Feedbacks::RepliesController < AdminController
  def create
    @feedback = Feedback.find params[:feedback_id]
    @reply = Feedback::Reply.create reply_params
    respond_with @reply, action: 'admin/feedbacks/show', location: admin_feedback_path(@feedback)
  end

  private

  def reply_params
    params.require(:reply)
          .permit(
              :comment
          )
          .merge(
              user: current_user,
              feedback: @feedback
          )
  end
end
