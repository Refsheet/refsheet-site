/*
 * decaffeinate suggestions:
 * DS001: Remove Babel/TypeScript constructor workaround
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React, { Component } from 'react'
import PropTypes from 'prop-types'
import replace from 'react-string-replace'
import { Link } from 'react-router-dom'

class RichText extends Component {
  constructor(props) {
    super(props)

    this.handleSubmit = this.handleSubmit.bind(this)
    this.handleChange = this.handleChange.bind(this)
    this.state = { content: props.content }
  }

  UNSAFE_componentWillReceiveProps(newProps) {
    if (this.state.content !== newProps.content) {
      return this.setState({ content: newProps.content })
    }
  }

  handleSubmit(e) {
    e.preventDefault()
    const data = {}
    data[this.props.name] = this.state.content
    return this.props.onChange(data)
  }

  handleChange(e) {
    return this.setState({ content: e.target.value })
  }

  renderContent(content) {
    if (!content || content === '') {
      return <p className={'caption'}>No Caption</p>
    }

    let filtered = content.replace(/^\s*(#\w+\s*)+$/gm, '')
    let n = 0

    filtered = replace(filtered, /#(\w+)/g, (match, i) => (
      <Link key={'hashtag-' + n++} to={`/explore/tag/${match}`}>
        #{match}
      </Link>
    ))

    filtered = replace(filtered, /\n/g, (match, i) => <br key={'br-' + n++} />)

    return filtered
  }

  render() {
    const { contentHtml, title, placeholder } = this.props
    const { content } = this.state

    const outerClassNames = []
    const headerClassNames = []
    const bodyClassNames = ['rich-text']

    if (this.props.renderAsCard) {
      outerClassNames.push('card')
      headerClassNames.push('card-header')
      bodyClassNames.push('card-content')
    }

    // TODO: Don't DangerouslySet, but use a proper render function. Yes, this broke Hashtags.
    return (
      <div className={outerClassNames.join(' ')}>
        {title && (
          <div className={headerClassNames.join(' ')}>
            <h2>{title}</h2>
          </div>
        )}

        <div className={bodyClassNames.join(' ')}>
          {content && content.length > 0 ? (
            <div dangerouslySetInnerHTML={{ __html: contentHtml }} />
          ) : (
            <p className="caption">
              {placeholder || 'This section unintentionally left blank.'}
            </p>
          )}
        </div>
      </div>
    )
  }
}

RichText.propTypes = {
  contentHtml: PropTypes.string.isRequired,
  content: PropTypes.string,
  title: PropTypes.string,
  placeholder: PropTypes.string,
}

export default RichText