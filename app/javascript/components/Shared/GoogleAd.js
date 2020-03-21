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

    // TODO: The adblock default text is uh, not so friendly when google doesn't have any ads to serve up.
    return (
      <div
        className={c('google-ad', className)}
        style={{ position: 'relative', minHeight: '5rem' }}
      >
        <div
          style={{
            position: 'absolute',
            zIndex: 0,
            textAlign: 'center',
            top: '50%',
            left: '1rem',
            right: '1rem',
            transform: 'translateY(-50%)',
          }}
        >
          <strong>Are you using an ad blocker?</strong>
          <br />
          <p style={{ fontSize: '0.8rem', color: 'rgba(255,255,255,0.5)' }}>
            That's cool. I totally get it. But, perhaps you should consider
            becoming a Patron? Patrons can turn off ads and feel good about it.
          </p>
        </div>
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
  adFormat: PropTypes.string,
  layoutKey: PropTypes.string,
  adSlot: PropTypes.string,
}

export default GoogleAd
