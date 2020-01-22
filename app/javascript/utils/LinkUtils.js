function buildHelpers(object) {
  let obj = { ...object }

  Object.keys(obj).map(key => {
    const match = key.match(/^(\w+)Route$/i)
    if (match) {
      const name = match[1]
      const route = obj[key]

      obj[name + 'Path'] = params => {
        return route + 'process'
      }

      obj[name + 'Url'] = params => {
        return obj.baseUrl + obj[name + 'Path'](params)
      }
    }
  })

  console.log({ obj })
  return obj
}

const LinkUtils = buildHelpers({
  baseUrl: 'https://dev1.refsheet.net:5000',

  // Asset Helpers

  // Forum URLs:

  forumDiscussionRoute: '/v2/forums/:forumId/:discussionId',
  forumPostRoute: '/v2/forums/:forumId/:discussionId#:postId',

  // forumDiscussionLink(forum, discussion, post=null) {
  //   let link = `/v2/forums/${forum.slug || forum}/${discussion.slug || discussion}`
  //
  //   if (post) {
  //     link += '#' + (post.id || post)
  //   }
  //
  //   return link
  // },
  //
  // forumDiscussionUrl(forum, discussion, post=null) {
  //   return this.baseUrl + this.forumDiscussionLink(forum, discussion, post)
  // }
})

export default LinkUtils
