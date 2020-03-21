import React from 'react'

const GoogleAd = ({ adFormat, layoutKey, adSlot }) => {
  return (
    <div className={'google-ad'}>
      <ins
        className="adsbygoogle"
        style={{ display: 'block' }}
        data-ad-format={adFormat || 'fluid'}
        data-ad-layout-key={layoutKey || '-f5+66+2b-d1+eu'}
        data-ad-client="ca-pub-4929509110499022"
        data-ad-slot={adSlot || '3997004779'}
      />
      <script>(adsbygoogle = window.adsbygoogle || []).push({});</script>
    </div>
  )
}

export default GoogleAd
