class AccountController < ApplicationController
  before_action :validate_signed_in

  private

  def validate_signed_in
    unless signed_in?
      head :unauthorized
      false
    end
  end
end
