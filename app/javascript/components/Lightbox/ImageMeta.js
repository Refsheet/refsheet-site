import React from 'react'
import { Icon } from 'react-materialize'
import RichText from '../Shared/RichText'
import { withNamespaces } from 'react-i18next'
import { Link } from 'react-router-dom'

const artists = [
  {
    name: 'Helixel',
    slug: 'helixel',
  },
]

const characterTags = [
  {
    startX: 20,
    endX: 20,
    startY: 20,
    character: {
      link: '#',
      name: 'Some Cool OC',
    },
  },
]

const mediaTags = ['demon', 'imp', 'totally_cool_oc', 'tags_are_a_thing']

const ImageMeta = ({
  id,
  caption,
  caption_html,
  source_url,
  source_url_display,
}) => (
  <div className={'image-meta'}>
    <div className={'image-caption'}>
      <RichText
        contentHtml={caption_html}
        content={caption}
        placeholder={'No Caption'}
      />
    </div>
    <ul className={'attributes'}>
      {source_url && (
        <li>
          <Icon className={'left'}>link</Icon>
          <a href={source_url} target={'_blank'} rel={'external nofollow'}>
            {source_url_display}
          </a>
        </li>
      )}

      {artists && (
        <li>
          <Icon className={'left'}>brush</Icon>
          {artists.map((artist, i) => (
            <span key={artist.slug}>
              <Link to={`/artists/${artist.slug}`}>{artist.name}</Link>
              {i + 1 < artists.length ? ', ' : ''}
            </span>
          ))}
        </li>
      )}

      {characterTags && (
        <li>
          <Icon className={'left'}>tag_faces</Icon>
          {characterTags.map((characterTag, i) => (
            <span key={characterTag.character.link}>
              <Link to={characterTag.character.link}>
                {characterTag.character.name}
              </Link>
              {i + 1 < characterTags.length ? ', ' : ''}
            </span>
          ))}
        </li>
      )}

      {mediaTags && (
        <li>
          <Icon className={'left'}>tag</Icon>
          {mediaTags.map((mediaTag, i) => (
            <span key={mediaTag} className={'media-tag'}>
              <Link to={`/browse/tag/${mediaTag}`}>{mediaTag}</Link>
              {i + 1 < mediaTags.length ? ', ' : ''}
            </span>
          ))}
        </li>
      )}
    </ul>
  </div>
)

export default withNamespaces('common')(ImageMeta)
