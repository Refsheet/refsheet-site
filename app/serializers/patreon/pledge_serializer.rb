class Patreon::PledgeSerializer < ActiveModel::Serializer
  attributes :patreon_id,
             :amount_cents,
             :declined_since

  has_one :patron, serializer: Patreon::PatronSerializer
end