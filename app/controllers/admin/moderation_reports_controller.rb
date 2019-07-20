class Admin::ModerationReportsController < AdminController
  before_action :get_report, only: [:show, :update]
  def index
    scope = ModerationReport.all

    if params[:status]
      scope = scope.where(status: params[:status])
    else
      scope = scope.pending
    end

    if params[:violation_type]
      scope = scope.where(violation_type: params[:violation_type])
    end

    if (sender_id = User.lookup(params[:sender])&.id)
      scope = scope.where(sender_user_id: sender_id)
    end

    if (reported_id = User.lookup(params[:reported])&.id)
      scope = scope.where(user_id: reported_id)
    end

    @scope = @reports = scope.page(params[:page])
  end

  def show
  end

  def update
    case params[:report_action]
    when 'pass'
      @report.pass!
    when 'auto_resolve'
      flash[:notice] = "Moderation report resolved automatically."
      @report.auto_resolve!
    else
      flash[:error] = "State transition invalid"
      @report.errors.add :state, "transition invalid"
    end

    respond_to do |format|
      format.js
      format.html {
        if (next_id = ModerationReport.next&.id)
          redirect_to admin_moderation_report_path(next_id)
        else
          redirect_to admin_moderation_reports_path
        end
      }
    end
  end

  private

  def get_report
    @report = ModerationReport.find(params[:id])
  end
end