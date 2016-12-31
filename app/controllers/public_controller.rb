class PublicController < ApplicationController
  def health
    head :ok
  end
end
