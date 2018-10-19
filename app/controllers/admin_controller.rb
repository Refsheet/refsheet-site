class AdminController < ApplicationController
  before_action :validate_admin

  respond_to :html, :js, :json

  private

  def validate_admin
    unless current_user&.role? :admin
      redirect_to login_path next: url_for
    end
  end
end
