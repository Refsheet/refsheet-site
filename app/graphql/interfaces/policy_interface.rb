Interfaces::PolicyInterface = GraphQL::InterfaceType.define do
  name 'Policy'

  field :can_edit, types.Boolean do
    resolve -> (obj, _args, ctx) {
      user = ctx[:current_user].call
      !!Pundit.authorize(user, obj, :update?) rescue false
    }
  end

  field :can_destroy, types.Boolean do
    resolve -> (obj, _args, ctx) {
      user = ctx[:current_user].call
      !!Pundit.authorize(user, obj, :destroy?) rescue false
    }
  end
end
