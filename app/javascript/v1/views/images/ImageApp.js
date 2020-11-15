/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import CharacterViewSilhouette from 'v1/views/characters/CharacterViewSilhouette'
import { connect } from 'react-redux'
import { openLightbox } from '../../../actions'

import $ from 'jquery'
import Model from '../../utils/Model'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const ImageApp = createReactClass({
  getInitialState() {
    return { image: null }
  },

  load(data) {
    const { openLightbox } = this.props
    this.setState({ image: data }, function () {
      data.directLoad = true
      // TODO: We can direct load here.
      openLightbox(data.id)
      //       return $(document).trigger('app:lightbox', data)
    })
  },

  fetch(imageId) {
    if (!imageId) {
      return
    }
    return Model.get(`/images/${imageId}.json`, this.load)
  },

  UNSAFE_componentWillMount() {
    this.fetch(
      this.props.match != null ? this.props.match.params.imageId : undefined
    )
  },

  UNSAFE_componentWillReceiveProps(newProps) {
    if (
      (newProps.match != null ? newProps.match.params.imageId : undefined) &&
      this.state.image &&
      (newProps.match != null ? newProps.match.params.imageId : undefined) !==
        (this.state.image != null ? this.state.image.id : undefined)
    ) {
      this.fetch(
        newProps.match != null ? newProps.match.params.imageId : undefined
      )
    }
  },

  render() {
    if (this.state.image != null) {
      return (
        <CharacterViewSilhouette
          title={[this.state.image.title, 'Images']}
          coverImage={this.state.image.character.featured_image_url}
          immediate
        />
      )
    } else {
      return <CharacterViewSilhouette />
    }
  },
})

export default connect(undefined, { openLightbox })(ImageApp)

// BROKEN THINGS FOR TOMRROW

// Change eagerload to CONTEXT
// Loading screen broken?
// Character load on their own.
