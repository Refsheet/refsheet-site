import React, { Component } from 'react'
import PropTypes from 'prop-types'
import CommentForm from "../Shared/CommentForm"
import CreateActivity from './createActivity.graphql'
import {Mutation} from "react-apollo";

class StatusUpdate extends Component {
  handleSubmit({comment, identity}) {
    return this.props.post({
      variables: {
        comment,
        character_id: identity.character_id
      }
    })
  }

  render() {
    return (
      <CommentForm
        inCharacter
        placeholder={"What's on your mind, %n?"}
        buttonText="Post"
        onSubmit={this.handleSubmit.bind(this)}
      />
    )
  }
}

StatusUpdate.propTypes = {}

const withMutation = (props) => (
  <Mutation mutation={CreateActivity}>
    { (post, data) => (<StatusUpdate post={post} data={data} {...props} />) }
  </Mutation>
)

export default withMutation