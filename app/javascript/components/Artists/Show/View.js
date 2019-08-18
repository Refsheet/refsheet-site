import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Main from "../../Shared/Main";
import Header from "./Header";

class View extends Component {
  render() {
    const {
      artist: {
        name,
        avatar_url,
        profile,
        profile_markdown,
        user = {}
      }
    } = this.props

    return (
      <Main title={['Artist', name]}>
        <Header
          name={name}
          avatarUrl={avatar_url}
          username={user.username}
          profile={profile}
          profileMarkdown={profile_markdown}
        />
        <pre>{ JSON.stringify(this.props, undefined, 2) }</pre>
      </Main>
    )
  }
}

View.propTypes = {
  artist: PropTypes.shape({
    name: PropTypes.string.isRequired
  })
}

export default View