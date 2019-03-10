import React from 'react'
import PropTypes from 'prop-types'
import gql from "graphql-tag";
import {Subscription} from "react-apollo";

const Thumbnail = ({image, style}) => {
  const { url, title, aspect_ratio, image_processing } = image
  const { medium: src } = url

  const renderImage = () => {
    if (image_processing) {
      return (<div className='message center-align'>
        <i className={'material-icons'}>hourglass_empty</i>
        <div className='caption margin-top--large'>Image processing...</div>
        <div className='muted margin-top--medium'>
          Thumbnails are being generated for this image, and should be available soon.
          You might need to reload this page.
        </div>
      </div>)

    } else if (!aspect_ratio) {
      console.log({image})

      return (<div className='message center-align'>
        <i className={'material-icons'} style={'font-size: 3rem'}>warning</i>
        <div className='caption margin-top--medium red-text'>Invalid image :(</div>
        <div className='muted margin-top--medium'>
          Something's not quite right. This might be a bug. Report Image #{image.id}.
        </div>
      </div>)

    } else {
      return (<img src={ src } className='responsive-img block' alt={ title }/>)
    }
  }

  return (<div style={style} className='image-thumbnail black z-depth-1'>
    { renderImage() }
  </div>)
}

const IMAGE_SUBSCRIPTION = gql`
  subscription onImageProcessingComplete($imageId: ID!) {
    imageProcessingComplete(imageId: $imageId) {
      id
      title
      nsfw
      hidden
      background_color
      aspect_ratio
      comments_count
      favorites_count
      image_processing
      is_favorite
      is_managed
      width
      height
      url {
          small
          medium
      }
      size {
          small {
              width
              height
          }
          medium {
              width
              height
          }
      }
    }
  }
`

Thumbnail.propTypes = {
  image: PropTypes.shape({
    url: PropTypes.shape({
      medium: PropTypes.string.isRequired
    }).isRequired,
    size: PropTypes.shape({
      medium: PropTypes.shape({
        width: PropTypes.number.isRequired,
        height: PropTypes.number.isRequired
      }).isRequired
    }).isRequired,
    image_processing: PropTypes.bool
  })
}

const renderSubscribed = (props) => ({data, loading, error}) => {
  let image = props.image
  console.log({loading, data, error})

  if (!loading && data && data.imageProcessingComplete) {
    image = data.imageProcessingComplete
  }

  return <Thumbnail {...props} image={image} />
}

const Subscribed = (props) => {
  if(props.image.image_processing) {
    return <Subscription subscription={IMAGE_SUBSCRIPTION} variables={{ imageId: props.image.id }}>
      {renderSubscribed(props)}
    </Subscription>
  } else {
    return <Thumbnail {...props} />
  }
}

export default Subscribed
