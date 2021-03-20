import React from 'react'
import { withCurrentUser } from '../../../../../utils/compose'
import { restrict } from '../../../../Shared/Restrict'

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
const MarketplaceListing = ({ currentUser, character }) => {
  if (restrict({ currentUser, patron: true })) {
    const { marketplace_listing } = character
    console.log({ marketplace_listing })

    return <div>{JSON.stringify(marketplace_listing)}</div>
  } else {
    return (
      <div>
        <p className={'caption center margin-top--large'}>
          This feature is currently only available to Patrons and Site
          Supporters.
        </p>
      </div>
    )
  }
}

export default withCurrentUser()(MarketplaceListing)
