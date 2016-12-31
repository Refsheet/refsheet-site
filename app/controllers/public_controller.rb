class PublicController < ApplicationController
  def health
    head :ok
  end

  protected

  def allow_http?
    true
  end
end
