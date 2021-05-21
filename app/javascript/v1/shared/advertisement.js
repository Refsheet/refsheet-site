import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import StateUtils from 'v1/utils/StateUtils'
import GoogleAd from '../../components/Shared/GoogleAd'
import ahoy from 'ahoy.js'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let Advertisement
export default Advertisement = createReactClass({
  dataPath: '/our_friends/next',

  getInitialState() {
    return { campaign: null }
  },

  componentDidMount() {
    return StateUtils.load(this, 'campaign')
  },

  _handleImageLoad(e) {
    return ahoy.track('advertisement.impression', {
      advertisement_id: this.state.campaign.id,
      image_file_name: e.target.src,
      current_slot_id: this.state.campaign.current_slot_id,
    })
  },

  _handleLinkClick(e) {
    return ahoy.track('advertisement.click', {
      advertisement_id: this.state.campaign.id,
    })
  },

  _generateLink() {
    return 'https://ref.st/l/' + this.state.campaign.id
  },

  renderNativeAd() {
    if (!this.state.campaign) {
      return null
    }
    const { title, caption, link, image_url } = this.state.campaign

    const imageSrc = image_url.medium + '?c=' + Math.floor(Date.now() / 1000)

    return (
      <div
        className="sponsored-content margin-bottom--large"
        style={{
          boxSizing: 'border-box',
          overflow: 'hidden',
          fontSize: '0.8rem',
          padding: '0 0 1rem 0',
        }}
      >
        <div
          className="sponsor-blurb"
          style={{
            fontSize: '0.9rem',
            color: 'rgba(255, 255, 255, 0.3)',
            paddingBottom: '0.2rem',
            marginBottom: '1rem',
            borderBottom: '1px solid rgba(255, 255, 255, 0.1)',
          }}
        >
          From our Friends:
        </div>

        <div
          className="blurb-container"
          style={{
            maxWidth: 220,
            margin: '0 auto',
            textAlign: 'center',
          }}
        >
          <a
            href={this._generateLink()}
            target="_blank"
            onClick={this._handleLinkClick}
            rel="noopener noreferrer"
          >
            <img
              className="responsive-img"
              src={imageSrc}
              alt={title}
              width="200px"
              height="150px"
              onLoad={this._handleImageLoad}
            />
          </a>

          <a
            href={this._generateLink()}
            target="_blank"
            className="grey-text text-darken-2 block"
            onClick={this._handleLinkClick}
            rel="noopener noreferrer"
            style={{
              textDecoration: 'underline',
              fontSize: '0.9rem',
              marginBottom: '0.3rem',
              marginTop: '0.5rem',
            }}
          >
            {title}
          </a>

          <div className="sponsor-blurb grey-text text-darken-2">
            {caption.substring(0, 90)}
          </div>
        </div>
      </div>
    )
  },

  render() {
    return <div>{this.renderNativeAd()}</div>
  },
})
