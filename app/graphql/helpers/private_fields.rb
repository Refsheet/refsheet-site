module Helpers::PrivateFields
  def private_field(name, type, **options)
    field name, type, **options do
      resolve -> (obj, _args, ctx) {
        Pundit.authorize(ctx[:current_user].call, obj, :show_private?)
        options[:hash_key] ? obj[options[:hash_key]] : obj.send(name)
      }
    end
  end
end
