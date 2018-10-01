Types::ImageUploadTokenType = GraphQL::ObjectType.define do
  name "ImageUploadToken"

  field :key, types.String
  field :acl, types.String
  field :success_action_status, types.String
  field :policy, types.String
  field :x_amz_credential, types.String
  field :x_amz_algorithm, types.String
  field :x_amz_date, types.String
  field :x_amz_signature, types.String
  field :url, types.String
end
