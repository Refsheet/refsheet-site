/* eslint-disable
    no-undef,
    no-unused-vars,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.Forums.Show = createReactClass({
  contextTypes: {
    eagerLoad: PropTypes.object,
  },

  dataPath: '/forums/:forumId',
  paramMap: {
    forumId: 'slug',
  },

  poller: null,

  getInitialState() {
    return {
      forum: null,
      threadScope: 'recent',
    }
  },

  componentWillMount() {
    return StateUtils.load(this, 'forum', this.props, forum => {
      if (forum) {
        return this._poll()
      }
    })
  },

  componentWillUnmount() {
    return clearTimeout(this.poller)
  },

  _poll() {
    return (this.poller = setTimeout(() => {
      return Model.poll(this.state.forum.path, {}, data => {
        if (data.id === this.state.forum.id) {
          this.setState({ forum: data })
        }
        return this._poll()
      })
    }, 15000))
  },

  componentWillReceiveProps(newProps) {
    return StateUtils.reload(this, 'forum', newProps)
  },

  _handleThreadReply(post) {
    const [thread, i] = Array.from(
      HashUtils.findItem(this.state.forum.threads, post.thread_id, 'id')
    )
    thread.posts_count += 1
    return StateUtils.updateItem(this, 'forum.threads', thread, 'id')
  },

  render() {
    if (!this.state.forum) {
      return <Loading />
    }
    console.log(this.props)

    const childrenWithProps = React.Children.map(this.props.children, child => {
      return React.cloneElement(child, { onReply: this._handleThreadReply })
    })

    return (
      <Main title={this.state.forum.name} fadeEffect flex>
        <Jumbotron className="short">
          <h1>{this.state.forum.name}</h1>
          <p>{this.state.forum.description}</p>
        </Jumbotron>

        <Container flex>
          <div className="sidebar sidebar-flex">
            <Forums.Threads.List
              forumId={this.props.match.params.forumId}
              threads={this.state.forum.threads}
              activeThreadId={this.props.match.params.threadId}
            />
          </div>

          <div className="content">
            {childrenWithProps || (
              <EmptyList caption="Select a thread to start chatting." />
            )}
          </div>
        </Container>

        <FixedActionButton
          icon="add"
          href="#new-thread-modal"
          className="modal-trigger"
          tooltip="New Thread"
        />
        <Forums.Threads.Modal forumId={this.state.forum.slug} />
      </Main>
    )
  },
})
