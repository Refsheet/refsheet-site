import React from 'react'

/**
 #  id                 :integer          not null, primary key
 #  seller_user_id     :integer
 #  character_id       :integer
 #  type               :string
 #  title              :string
 #  description        :text
 #  amount_cents       :integer          default(0), not null
 #  amount_currency    :string           default("USD"), not null
 #  requires_character :boolean
 #  published_at       :datetime
 #  expires_at         :datetime
 #  created_at         :datetime         not null
 #  updated_at         :datetime         not null
 #  sold               :boolean
 #  seller_id          :integer

 * @returns {JSX.Element}
 * @constructor
 */
const MarketplaceListing = () => {
  return <div>mkptlc</div>
}

export default MarketplaceListing
