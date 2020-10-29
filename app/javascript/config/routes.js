export default {
  baseUrl: 'http://localhost:5000',

  // Users
  userRoute: '/:username',
  characterRoute: '/:username/:slug',

  // Asset Helpers

  // Forum URLs:

  forumRoute: '/v2/forums/:forumId',
  newForumDiscussionRoute: '/v2/forums/:forumId/post',
  forumAboutRoute: '/v2/forums/:forumId/about',
  forumMembersRoute: '/v2/forums/:forumId/members',

  forumDiscussionRoute: '/v2/forums/:forumId/:discussionId',
  forumPostRoute: '/v2/forums/:forumId/:discussionId#:postId',
}
