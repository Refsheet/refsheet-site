import React, { Component } from 'react'
import PropTypes from 'prop-types'
import View from "./View";
import {Query} from "react-apollo";
import { getArtist } from './getArtist.graphql'
import Error from "../../Shared/Error";

class Show extends Component {
  render() {
    const variables = {
      slug: this.props.match.params.slug
    }

    return (
      <Query query={getArtist} variables={variables}>
        {({data, loading, errors}) => {
          console.log({data, loading, errors})
          if (loading) return <Loading />
          else if (errors) return <Error error={errors} />
          else return <View artist={data.getArtist} />
        }}
      </Query>
    )
  }
}

Show.propTypes = {
  match: PropTypes.shape({
    params: PropTypes.shape({
      slug: PropTypes.string.isRequired
    })
  })
}

export default Show