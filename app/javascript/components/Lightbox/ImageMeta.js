import React from 'react'
import { Icon } from 'react-materialize'
import RichText from '../Shared/RichText'
import replace from 'react-string-replace'
import { withNamespaces } from 'react-i18next'
import { Link } from 'react-router-dom'

const artists = []

function renderContent(content) {
  if (!content || content === "") {
    return <p className={'caption'}>No Caption</p>
  }

  return replace(content, /#(\w+)/g, (match, i) => (
    <Link key={i} to={`/browse/tag/${match}`}>#{match}</Link>
  ));
}

const ImageMeta = ({
  id,
  caption,
  caption_html,
  source_url,
  source_url_display,
  tags,
  hashtags,
}) => (
  <div className={'image-meta'}>
    <div className={'image-caption'}>
      { renderContent(caption) }
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

      {artists.length > 0 && (
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

      {tags.length > 0 && (
        <li>
          <Icon className={'left'}>tag_faces</Icon>
          {tags.map((characterTag, i) => (
            <span key={characterTag.character.link}>
              <Link to={characterTag.character.link}>
                {characterTag.character.name}
              </Link>
              {i + 1 < characterTags.length ? ', ' : ''}
            </span>
          ))}
        </li>
      )}

      {hashtags.length > 0 && (
        <li>
          <Icon className={'left'}>tag</Icon>
          {hashtags.map(({ tag: mediaTag }, i) => (
            <span key={mediaTag} className={'media-tag'}>
              <Link to={`/browse/tag/${mediaTag}`}>{mediaTag}</Link>
              {i + 1 < hashtags.length ? ', ' : ''}
            </span>
          ))}
        </li>
      )}
    </ul>
  </div>
)

export default withNamespaces('common')(ImageMeta)
