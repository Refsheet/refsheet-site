import React from 'react'
import { Icon } from 'react-materialize'

const ImageMeta = ({id, caption_html, source_url, source_url_display}) => (
  <div className={'image-meta'}>
    <div className={'image-caption'}>
      <div dangerouslySetInnerHTML={{__html: caption_html}} />
    </div>
    <ul className={'attributes'}>
      { source_url && <li>
        <Icon className={'left'}>link</Icon>
        <a href={source_url} target={'_blank'} rel={'external nofollow'}>{ source_url_display }</a>
      </li> }
      <li>
        <Icon className={'left'}>report</Icon>
        <a href={'#'}>Report Image</a>
      </li>
    </ul>
  </div>
)

export default ImageMeta