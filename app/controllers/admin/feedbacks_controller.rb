class Admin::FeedbacksController < AdminController
  before_action :get_feedback, only: [:show, :update]

  before_action do
    @search = { path: admin_feedbacks_path }
  end

  def index
    @feedbacks = @scope = filter_scope Feedback
    @feedbacks = taper_group @feedbacks
  end

  def show
    @reply = Feedback::Reply.new
  end

  def update
    @feedback.update_attributes feedback_params
    respond_with :admin, @feedback
  end

  private

  def get_feedback
    @feedback = Feedback.find params[:id]
  end

  def feedback_params
    params.require(:feedback)
          .permit(
              :done
          )
  end
end
