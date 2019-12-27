import React from 'react'

const Silhouette = ({ children }) => (
  <div className={'lightbox-content silhouette'}>
    <div className={'image-content'}>{children}</div>

    <div className={'image-details-container'}>
      <div className="image-details">
        <div className={'character-box'}>
          <div className={'character-avatar'} />
          <div className={'character-details'}>
            <div className={'name'}>&nbsp;</div>
            <div className={'date'}>&nbsp;</div>
          </div>
        </div>
        <div className={'image-meta'}>
          <div className={'image-caption'}>
            <span className={'line1'}>&nbsp;</span>
            <span className={'line2'}>&nbsp;</span>
          </div>
        </div>
      </div>
    </div>
  </div>
)

export default Silhouette
