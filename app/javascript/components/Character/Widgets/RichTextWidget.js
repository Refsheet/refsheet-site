import React, { Component } from 'react'
import PropTypes from 'prop-types'
import MarkdownEditor from '../../Shared/MarkdownEditor'

class RichTextWidget extends Component {
  constructor(props) {
    super(props)
  }

  handleMarkdownChange(content) {
    this.props.onChange({ content })
  }

  render() {
    const { contentHtml } = this.props

    if (this.props.editing) {
      return (
        <div className={'rich-text-widget editing'}>
          <MarkdownEditor
            content={this.props.content}
            onChange={this.handleMarkdownChange.bind(this)}
          />
        </div>
      )
    }

    return (
      <div className="rich-text-widget">
        <div className="card-content rich-text">
          {contentHtml && contentHtml.length > 0 ? (
            <div dangerouslySetInnerHTML={{ __html: contentHtml }} />
          ) : (
            <p className="caption">This section unintentionally left blank.</p>
          )}
        </div>
      </div>
    )
  }
}

RichTextWidget.propTypes = {
  content: PropTypes.string,
  contentHtml: PropTypes.string,
  editing: PropTypes.bool,
  onChange: PropTypes.func.isRequired,
}

export default RichTextWidget
