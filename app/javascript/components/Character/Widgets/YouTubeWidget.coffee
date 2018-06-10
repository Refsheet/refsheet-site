import PropTypes from 'prop-types'
import getVideoId from 'get-video-id'

YouTubeWidget = ({videoUrl}) ->
  { id, service } = getVideoId videoUrl

  if service isnt 'youtube'
    return \
      `<div className='widget-error red-text card-content'>
        Invalid YouTube URL!
      </div>`

  `<div className='youtube-widget'>
    <div className='video-container'>
      <iframe width="560"
              height="315"
              src={"https://youtube.com/embed/" + id}
              frameBorder="0"
              allowFullScreen
      />
    </div>
  </div>`

YouTubeWidget.propTypes =
  videoUrl: PropTypes.string.isRequired
  caption: PropTypes.string

export default YouTubeWidget
