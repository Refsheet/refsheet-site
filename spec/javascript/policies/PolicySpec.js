import { expect } from 'chai'
import authorize, { Policy } from 'policies/Policy'

describe('Policy', () => {
  def('type', () => 'Character')
  def('object', () => ({ __typename: $type, user_id: 4 }))
  def('user', () => ({ id: 4 }))
})
