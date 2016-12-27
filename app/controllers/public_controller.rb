class PublicController < ApplicationController
  def show
    render template: "public/#{params[:page]}"
  rescue ActionView::MissingTemplate => e
    @error = e
    render template: "public/404", status: :not_found
  end
end
