class ReportsController < ApplicationController
  before_action :get_media

  def create
    @report = ModerationReport.new report_params

    if @report.save
      render json: { id: @report.id }, status: :ok
    else
      render json: { errors: @report.errors }, status: :bad_request
    end
  end

  private

  def get_media
    @media = Image.find_by!(guid: params[:moderation_report][:image_id])
  end

  def report_params
    params.require(:moderation_report)
          .permit(
              :violation_type,
              :comment,
              :dmca_source_url
          )
          .merge(
              sender: current_user,
              moderatable: @media
          )
  end
end
