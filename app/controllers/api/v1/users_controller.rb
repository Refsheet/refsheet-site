# See: http://jsonapi-rb.org/guides/getting_started/rails.html
class Api::V1::UsersController < ApiController
  def show
    user = User.find_by!(guid: params[:id])
    render jsonapi: user
  end

  def lookup
    user = User.find_by!('LOWER(users.username) = ?', params[:username]&.downcase)
    render jsonapi: user
  end
end