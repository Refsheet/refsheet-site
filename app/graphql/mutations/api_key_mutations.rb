class Mutations::ApiKeyMutations < Mutations::ApplicationMutation
  action :create do
    type Types::ApiKeyType

    argument :name, types.String
    argument :read_only, types.Boolean
  end

  def create
    authorize! current_user
    @key = ApiKey.create(create_params)
    @key
  end

  private

  def create_params
    params.permit(:name, :read_only).merge(user: current_user)
  end
end