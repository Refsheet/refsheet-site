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
import WindowAlert from '../../utils/WindowAlert'
import { H2 } from '../Styled/Headings'
import { sanitize } from '../../utils/sanitize'

class RichText extends Component {
  constructor(props) {
    super(props)

    this.handleSubmit = this.handleSubmit.bind(this)
    this.handleChange = this.handleChange.bind(this)

    this.state = {
      content: props.content,
      editing: false,
      saving: false,
      dirty: false,
    }

    this.Showdown = new Showdown.Converter({
      tables: true,
      simplifiedAutoLink: true,
      strikethrough: true,
      tasklists: true,
    })
  }

  componentDidUpdate(prevProps, prevState) {
    if (this.state.dirty !== prevState.dirty) {
      const dirtyKey = 'richtext:' + this.props.name
      if (this.state.dirty) {
        WindowAlert.dirty(dirtyKey)
      } else {
        WindowAlert.clean(dirtyKey)
      }
    }
  }

  UNSAFE_componentWillReceiveProps(newProps) {
    if (this.state.content !== newProps.content) {
      return this.setState({ content: newProps.content, dirty: false })
    }
  }

  handleSubmit(e) {
    e.preventDefault()

    const data = {}
    data[this.props.name || 'value'] = this.state.content

    return this.props
      .onChange(data)
      .then(newData => {
        this.setState({
          content: newData[this.props.name || 'value'],
          editing: false,
          dirty: false,
          saving: false,
        })
      })
      .catch(e => {
        this.setState({ saving: false })
        console.error(e)
      })
  }

  handleMarkdownChange(name, content) {
    this.setState({ content, dirty: true })
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
    this.setState({ editing: false, dirty: false, content: this.props.content })
  }

  render() {
    const {
      contentHtml,
      title,
      placeholder,
      onChange,
      titleComponent: Title = H2,
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
                margin: '-1rem' + (this.props.renderAsCard ? '' : ' 0 -1rem 0'),
                lineHeight: '1.2rem',
                borderRadius: this.props.renderAsCard ? 0 : undefined,
              }}
              data-testid={'rt-cancel'}
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
            content={this.state.content || ''}
            onChange={this.handleMarkdownChange.bind(this)}
          />

          <div className={'card-action'}>
            <div className={'right-align'}>
              <Button
                onClick={this.handleSubmit.bind(this)}
                data-testid={'rt-save'}
              >
                <i className={'material-icons left'}>save</i>
                Save
              </Button>
            </div>
          </div>
        </div>
      )
    }

    const contentPresent = content && /\S/.test(content)

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
                  margin:
                    '-1rem' + (this.props.renderAsCard ? '' : ' 0 -1rem 0'),
                  lineHeight: '1.2rem',
                  borderRadius: this.props.renderAsCard ? 0 : undefined,
                }}
                onClick={this.handleEditClick.bind(this)}
                data-testid={'rt-edit'}
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
          {contentPresent ? (
            <div
              dangerouslySetInnerHTML={{
                __html: sanitize(contentHtml),
              }}
            />
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
