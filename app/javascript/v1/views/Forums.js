// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Index from './forums/index'
import Show from './forums/show'
import ThreadsShow from './forums/threads/show'

const Forums = {
  Index,
  Show,
  Threads: {
    Show: ThreadsShow,
  },
}

export default Forums
