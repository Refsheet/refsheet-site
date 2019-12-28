class EmailsController < ApplicationController
  def unsubscribe
    @verified = Rails.application.message_verifier('emails').verify(params[:email])
  end
end