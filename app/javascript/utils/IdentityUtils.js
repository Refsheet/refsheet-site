import PropTypes from "prop-types";

export function createIdentity({user, character, identity}) {
  if (identity) {
    return identity
  } else if (character) {
    return {
      name: character.name,
      avatarUrl: (character.profile_image_url || character.profile_image.url.thumbnail),
      username: user.username,
      path: `/${user.username}/${character.slug}`,
      type: 'character',
      characterId: character.id
    }
  } else {
    return {
      name: user.name,
      avatarUrl: user.avatar_url,
      username: user.username,
      path: `/${user.username}`,
      type: 'user',
      characterId: null
    }
  }
}

export const userIdentitySourceType = {
  name: PropTypes.string.isRequired,
  username: PropTypes.string.isRequired,
  is_admin: PropTypes.boolean,
  is_patron: PropTypes.boolean,
  is_moderator: PropTypes.boolean,
  avatar_url: PropTypes.string
}

export const characterIdentitySourceType = {
  name: PropTypes.string.isRequired,
  slug: PropTypes.string.isRequired,
  profile_image: PropTypes.shape({
    url: PropTypes.shape({
      thumbnail: PropTypes.string.isRequired
    })
  })
}

export const identityType = {
  name: PropTypes.string.isRequired,
  avatarUrl: PropTypes.string.isRequired,
  username: PropTypes.string.isRequired,
  type: PropTypes.string.isRequired,
  path: PropTypes.string.isRequired,
  characterId: PropTypes.number
}

export const identitySourceType = {
  user: PropTypes.shape(userIdentitySourceType).isRequired,
  character: PropTypes.shape(characterIdentitySourceType),
  identity: PropTypes.shape(identityType)
}