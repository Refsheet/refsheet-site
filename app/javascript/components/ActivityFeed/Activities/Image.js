/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Row from 'v1/shared/material/Row'
import Column from 'v1/shared/material/Column'
import GalleryImage from 'v1/shared/images/GalleryImage'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let Image
export default Image = createReactClass({
  propTypes: {
    images: PropTypes.array.isRequired,
    character: PropTypes.object,
    action: PropTypes.string,
  },

  _getGallery() {
    return (
      (this.props.images &&
        this.props.images.filter(i => !!i).map(i => i.id)) ||
      []
    )
  },

  _buildSingle(key, one) {
    return (
      <Row noMargin noGutter key={key}>
        <Column>
          <GalleryImage
            gallery={this._getGallery()}
            image={one}
            size="medium_square"
          />
        </Column>
      </Row>
    )
  },

  _buildDouble(key, one, two) {
    return (
      <Row noMargin noGutter key={key}>
        <Column s={6}>
          <GalleryImage
            gallery={this._getGallery()}
            image={one}
            size="medium_square"
          />
        </Column>
        <Column s={6}>
          <GalleryImage
            gallery={this._getGallery()}
            image={two}
            size="medium_square"
          />
        </Column>
      </Row>
    )
  },

  _buildTriple(key, one, two, three) {
    return (
      <Row noMargin noGutter key={key}>
        <Column s={8}>
          <GalleryImage
            gallery={this._getGallery()}
            image={one}
            size="medium_square"
          />
        </Column>
        <Column s={4}>
          <Row noMargin noGutter>
            <Column>
              <GalleryImage
                gallery={this._getGallery()}
                image={two}
                size="medium_square"
              />
            </Column>
            <Column>
              <GalleryImage
                gallery={this._getGallery()}
                image={three}
                size="medium_square"
              />
            </Column>
          </Row>
        </Column>
      </Row>
    )
  },

  _buildImageGrid(images, grid) {
    if (grid == null) {
      grid = []
    }

    const key = images.length

    // 3 Block: 3, 5, 6
    if ((images.length > 4 && images.length < 7) || images.length === 3) {
      const [one, two, three, ...more] = Array.from(images)
      grid.push(this._buildTriple(key, one, two, three))
      this._buildImageGrid(more, grid)

      // 2 Block: 2, 4, 7+
    } else if (
      images.length === 2 ||
      images.length === 4 ||
      images.length >= 7
    ) {
      const [one, two, ...more] = Array.from(images)
      grid.push(this._buildDouble(key, one, two))
      this._buildImageGrid(more, grid)

      // Single: 1
    } else if (images.length === 1) {
      const [one] = Array.from(images)
      grid.push(this._buildSingle(key, one))
    }

    return grid
  },

  render() {
    // Reject NULLs here, see: REFST-2DP
    let images = this.props.images.filter(i => !!i)

    if (this.props.character) {
      images.map(i => {
        i.character = this.props.character
      })
    }

    return <div className="activity">{this._buildImageGrid(images)}</div>
  },
})
