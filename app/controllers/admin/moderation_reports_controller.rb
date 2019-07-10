class Admin::ModerationReportsController < AdminController
  before_action :get_report, only: [:show, :update]
  def index
    scope = ModerationReport.all
    scope = scope.pending

    @scope = @reports = scope.page(params[:page])
  end

  def update
    case params[:report_action]
    when 'pass'
      @report.pass!
    when 'auto_resolve'
      @report.auto_resolve!
    else
      @report.errors.add :state, "transition invalid"
    end
  end

  private

  def get_report
    @report = ModerationReport.find(params[:id])
  end
end