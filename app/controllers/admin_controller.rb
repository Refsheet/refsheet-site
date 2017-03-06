class AdminController < ApplicationController
  before_action :validate_admin

  private

  def validate_admin
    unless current_user&.role? :admin
      raise ActionController::RoutingError.new('Schrodinger\'s Controller')
    end
  end
end