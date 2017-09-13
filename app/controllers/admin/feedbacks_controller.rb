class Admin::FeedbacksController < AdminController
  before_action :get_feedback, only: [:show]

  before_action do
    @search = { path: admin_feedbacks_path }
  end

  def index
    @feedbacks = @scope = filter_scope Feedback
    @feedbacks = taper_group @feedbacks
  end

  def show
  end

  private

  def get_feedback
    @feedback = Feedback.find params[:id]
  end
end
