import React, { Component } from 'react'
import PropTypes from 'prop-types'
import MarkdownEditor from '../../Shared/MarkdownEditor'
import { sanitize } from '../../../utils/sanitize'

class RichTextWidget extends Component {
  constructor(props) {
    super(props)
  }

  handleMarkdownChange(name, content) {
    this.props.onChange({ content })
  }

  render() {
    const { contentHtml, content, editing } = this.props

    if (editing) {
      return (
        <div className={'rich-text-widget editing'}>
          <MarkdownEditor
            name={'value'}
            content={content}
            onChange={this.handleMarkdownChange.bind(this)}
          />
        </div>
      )
    }

    return (
      <div className="rich-text-widget">
        <div className="card-content rich-text">
          {contentHtml && contentHtml.length > 0 ? (
            <div
              dangerouslySetInnerHTML={{
                __html: sanitize(contentHtml),
              }}
            />
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
