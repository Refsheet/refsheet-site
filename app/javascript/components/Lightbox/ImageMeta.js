import React from 'react'
import { Icon } from 'react-materialize'
import RichText from '../Shared/RichText'
import replace from 'react-string-replace'
import { withTranslation } from 'react-i18next'
import { Link } from 'react-router-dom'

const artists = []

const ImageMeta = ({
  id,
  caption,
  caption_html,
  source_url,
  source_url_display,
  tags,
  hashtags,
  hidden,
  image_processing,
  nsfw,
  is_v2_image,
  t,
}) => (
  <div className={'image-meta'}>
    <div className={'image-caption'}>
      <RichText content={caption} contentHtml={caption_html} />
    </div>
    <ul className={'attributes'}>
      {hidden && (
        <li>
          <Icon className={'left'}>visibility_off</Icon>
          {t('labels.hidden', 'Hidden')}
        </li>
      )}

      {nsfw && (
        <li>
          <Icon className={'left'}>remove_circle</Icon>
          {t('labels.nsfw', 'NSFW')}
        </li>
      )}

      {image_processing && (
        <li>
          <Icon className={'left'}>hourglass_empty</Icon>
          {t('images.processing', 'Image Processing...')}
        </li>
      )}

      {is_v2_image && (
        <li>
          <Icon className={'left'}>alert</Icon>
          {t('images.is_v2_image', 'V2 Upload!')}
        </li>
      )}

      {source_url && (
        <li>
          <Icon className={'left'}>link</Icon>
          <a
            href={source_url}
            target={'_blank'}
            rel="external nofollow noopener noreferrer"
          >
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
              {i + 1 < tags.length ? ', ' : ''}
            </span>
          ))}
        </li>
      )}

      {hashtags.length > 0 && (
        <li>
          <Icon className={'left'}>tag</Icon>
          {hashtags.map(({ tag: mediaTag }, i) => (
            <span key={mediaTag} className={'media-tag'}>
              <Link to={`/explore/tag/${mediaTag}`}>{mediaTag}</Link>
              {i + 1 < hashtags.length ? ', ' : ''}
            </span>
          ))}
        </li>
      )}
    </ul>
  </div>
)

export default withTranslation('common')(ImageMeta)
