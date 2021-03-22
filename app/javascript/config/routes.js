export default {
  baseUrl: 'http://localhost:5000',

  // Users
  userRoute: '/:username',
  characterRoute: '/:username/:slug',

  // Asset Helpers

  // Forum URLs:

  forumRoute: '/forums/:forumId',
  newForumDiscussionRoute: '/forums/:forumId/post',
  forumAboutRoute: '/forums/:forumId/about',
  forumMembersRoute: '/forums/:forumId/members',

  forumDiscussionRoute: '/forums/:forumId/:discussionId',
  forumPostRoute: '/forums/:forumId/:discussionId#:postId',
}
