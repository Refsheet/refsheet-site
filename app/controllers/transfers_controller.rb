class TransfersController < ApplicationController
  before_action :get_transfer

  def update
    if params[:status] == 'rejected'
      @transfer.reject
    elsif params[:status] == 'claimed'
      @transfer.claim
    else
      render json: { error: "Status must be rejected or accepted" }, status: :bad_request
      return false
    end

    if @transfer.valid?
      render json: @transfer, serializer: CharacterTransferSerializer
    else
      render json: { errors: @transfer.errors }, status: :bad_request
    end
  end

  private

  def get_transfer
    @transfer = Transfer.find_by! guid: params[:id]

    unless @transfer.destination == current_user
      head :unauthorized
    end
  end
end
