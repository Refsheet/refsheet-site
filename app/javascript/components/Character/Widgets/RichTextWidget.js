import React, { Component } from 'react'
import PropTypes from 'prop-types'

class RichTextWidget extends Component {
  constructor(props) {
    super(props)

    this.state = {
      editable: false,
    }
  }

  render() {
    const {content, contentHtml, title} = this.props

    return (
      <div className='rich-text-widget'>
        <div className='card-content rich-text'>
          { contentHtml && contentHtml.length > 0
            ? <div dangerouslySetInnerHTML={ { __html: contentHtml } }/>
            : <p className='caption'>This section unintentionally left blank.</p> }
        </div>
      </div>
    )
  }
}

RichTextWidget.propTypes = {
  content: PropTypes.string,
  contentHtml: PropTypes.string
}

export default RichTextWidget