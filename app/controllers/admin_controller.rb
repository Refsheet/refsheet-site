class AdminController < ApplicationController
  before_action :validate_admin

  private

  def validate_admin
    unless current_user&.role? :admin
      flash[:error] = "You are not authorized to see this!"
      redirect_to login_path next: url_for
    end
  end
end
