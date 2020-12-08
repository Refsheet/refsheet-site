import authorize from 'policies'

describe('Policy', () => {
  def('type', () => 'Character')
  def('object', () => ({ __typename: $type, username: 'tacocat' }))
  def('user', () => ({ username: 'tacocat' }))

  it('authorizes policy', () => {
    expect(authorize($object, $user, 'show')).toBe(true)
  })
})
