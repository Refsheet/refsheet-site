class AccountController < ApplicationController
  before_action :validate_signed_in

  private

  def validate_signed_in
    unless signed_in?
      respond_to do |format|
        format.html { redirect_to login_path(next: url_for), flash: { error: 'You need to be signed in to access that.' } }
        format.any { head :unauthorized }
      end

      false
    end
  end
end
