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
import MarkdownEditor from './MarkdownEditor'
import c from 'classnames'
import * as Showdown from 'showdown'
import Button from '../../v1/shared/material/Button'

class RichText extends Component {
  constructor(props) {
    super(props)

    this.handleSubmit = this.handleSubmit.bind(this)
    this.handleChange = this.handleChange.bind(this)

    this.state = {
      content: props.content,
      editing: false,
    }

    this.Showdown = new Showdown.Converter({
      tables: true,
      simplifiedAutoLink: true,
      strikethrough: true,
      tasklists: true,
    })
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

  handleMarkdownChange(name, content) {
    this.setState({ content })
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

  handleEditClick(e) {
    e.preventDefault()
    this.setState({ editing: true })
  }

  handleEditStop(e) {
    e.preventDefault()
    this.setState({ editing: false })
  }

  render() {
    const {
      contentHtml,
      title,
      placeholder,
      onChange,
      titleComponent: Title = 'h2',
    } = this.props

    const { content } = this.state

    const outerClassNames = []
    const headerClassNames = []
    const bodyClassNames = ['rich-text']

    if (this.props.renderAsCard) {
      outerClassNames.push('card')
      headerClassNames.push('card-header')
      bodyClassNames.push('card-content')
    }

    if (this.state.editing) {
      return (
        <div className={c('editing', outerClassNames)}>
          <div className={headerClassNames.join(' ')}>
            <a
              className={'right btn btn-flat'}
              style={{
                height: '3.2rem',
                padding: '1rem',
                margin: '-1rem',
                lineHeight: '1.2rem',
                borderRadius: 0,
              }}
              data-test-id={'rt-cancel'}
              onClick={this.handleEditStop.bind(this)}
            >
              <i
                className={'material-icons'}
                style={{
                  height: '1.2rem',
                  lineHeight: '1.2rem',
                }}
              >
                cancel
              </i>
            </a>

            <Title>{title}</Title>
          </div>

          <MarkdownEditor
            content={this.state.content}
            onChange={this.handleMarkdownChange.bind(this)}
          />

          <div className={'card-action'}>
            <div className={'right-align'}>
              <Button
                onClick={this.handleSubmit.bind(this)}
                data-test-id={'rt-save'}
              >
                <i className={'material-icons left'}>save</i>
                Save
              </Button>
            </div>
          </div>
        </div>
      )
    }

    // TODO: Don't DangerouslySet, but use a proper render function. Yes, this broke Hashtags.
    return (
      <div className={outerClassNames.join(' ')}>
        {(title || onChange) && (
          <div className={headerClassNames.join(' ')}>
            {onChange && (
              <a
                className={'right btn btn-flat'}
                style={{
                  height: '3.2rem',
                  padding: '1rem',
                  margin: '-1rem',
                  lineHeight: '1.2rem',
                  borderRadius: 0,
                }}
                onClick={this.handleEditClick.bind(this)}
                data-test-id={'rt-edit'}
              >
                <i
                  className={'material-icons'}
                  style={{
                    height: '1.2rem',
                    lineHeight: '1.2rem',
                  }}
                >
                  edit
                </i>
              </a>
            )}

            <Title>{title}</Title>
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
  titleComponent: PropTypes.oneOfType([PropTypes.string, PropTypes.func]),
  placeholder: PropTypes.string,
  onChange: PropTypes.func,
  name: PropTypes.string,
}

export default RichText
