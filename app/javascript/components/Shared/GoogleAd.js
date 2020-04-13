/* global Refsheet */
import React, { Component } from 'react'
import PropTypes from 'prop-types'
import c from 'classnames'

class GoogleAd extends Component {
  componentDidMount() {
    if (window.adsbygoogle) {
      try {
        let result = window.adsbygoogle.push({})
        console.log('Initialized ad: ', result)
      } catch (e) {
        console.warn(e)
      }
    } else {
      console.debug('Adsbygoogle is not available yet.')
    }
  }

  render() {
    const { format, layoutKey, slot, className, ...rest } = this.props

    if (
      Refsheet.environment === 'test' ||
      Refsheet.environment === 'development'
    ) {
      return null
    }

    return (
      <div
        className={c('google-ad', className)}
        style={{ position: 'relative' }}
      >
        <ins
          className="adsbygoogle"
          style={{ display: 'block' }}
          data-ad-format={format}
          data-ad-layout-key={layoutKey}
          data-ad-client="ca-pub-4929509110499022"
          data-ad-slot={slot}
          {...rest}
        />
      </div>
    )
  }
}

GoogleAd.propTypes = {
  format: PropTypes.string,
  layoutKey: PropTypes.string,
  slot: PropTypes.string,
  className: PropTypes.string,
}

export default GoogleAd
