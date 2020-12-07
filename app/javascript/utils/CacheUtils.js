import { getCharacterProfile as gcp } from 'queries/getCharacterProfile.graphql'

const CacheUtils = {
  deleteMedia: (cache, { data: { deleteMedia } }) => {
    const { getCharacterByUrl } = cache.readQuery({
      query: gcp,
      variables: {
        username: deleteMedia.character.username,
        slug: deleteMedia.character.slug,
      },
    })
    cache.writeQuery({
      query: gcp,
      data: {
        getCharacterByUrl: {
          ...getCharacterByUrl,
          images: getCharacterByUrl.images.filter(i => i.id !== deleteMedia.id),
        },
      },
    })
  },
}

export default CacheUtils
