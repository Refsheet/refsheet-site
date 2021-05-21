Types::MarketplaceListingType = GraphQL::ObjectType.define do
  name "MarketplaceListing"
  interfaces [Interfaces::ApplicationRecordInterface]

  field :title, types.String
  field :amount_cents, types.Int
  field :amount_currency, types.String
end
