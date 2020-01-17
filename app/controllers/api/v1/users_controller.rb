class Api::V1::UsersController < ApiController
  def show
    user = User.find(params[:id])

    render jsonapi: user
  end
end