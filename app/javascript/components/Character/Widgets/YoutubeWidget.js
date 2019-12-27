import React, { Component } from 'react'
import PropTypes from 'prop-types'
import getVideoId from 'get-video-id'

class YoutubeWidget extends Component {
  constructor(props) {
    super(props)
  }

  handleUrlChange(e) {
    this.props.onChange({ url: e.target.value })
  }

  render() {
    const { url } = this.props

    if (this.props.editing) {
      return (
        <div className={'card-content'}>
          <input
            id="youtube-url"
            type={'url'}
            defaultValue={url}
            onChange={this.handleUrlChange.bind(this)}
          />
          <label htmlFor={'youtube-url'}>Video URL</label>
        </div>
      )
    }

    const { id, service } = getVideoId(url || '')

    if (service !== 'youtube') {
      return (
        <div className="widget-error red-text card-content">
          Invalid YouTube URL!
        </div>
      )
    } else {
      return (
        <div className="youtube-widget">
          <div className="video-container">
            <iframe
              width="560"
              height="315"
              src={'https://youtube.com/embed/' + id}
              frameBorder="0"
              allowFullScreen
            />
          </div>
        </div>
      )
    }
  }
}

YoutubeWidget.propTypes = {
  url: PropTypes.string,
  caption: PropTypes.string,
}

export default YoutubeWidget
