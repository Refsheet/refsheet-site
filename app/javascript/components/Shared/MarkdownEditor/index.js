import React, { Component } from 'react'
import PropTypes from 'prop-types'
import c from 'classnames'
import ReactMde from 'react-mde'
import * as Showdown from 'showdown'
import Autocomplete from './autocomplete.graphql'
import client from 'services/ApplicationService'
import './react-mde-overrides.scss'
import styled from 'styled-components'
import { sanitize } from '../../../utils/sanitize'

const SRM = styled(ReactMde)`
  background-color: ${props => props.theme.cardBackground} !important;
`

class MarkdownEditor extends Component {
  constructor(props) {
    super(props)

    this.state = {
      selectedTab: 'write',
    }

    this.Showdown = new Showdown.Converter({
      tables: true,
      simplifiedAutoLink: true,
      strikethrough: true,
      tasklists: true,
    })
  }

  searchForUser(username) {
    console.debug('searchForUser', { username })
    return new Promise(resolve => {
      client
        .query({
          query: Autocomplete.autocompleteUser,
          variables: { username },
        })
        .then(({ data, error }) => {
          if (!data) {
            console.error(error)
            resolve([])
          }

          const { autocompleteUser: users } = data

          resolve(
            (users || []).map(user => ({
              preview: (
                <span className={'markdown-editor--suggestion'}>
                  <span className={'value'}>{user.name}</span>
                  <span className={'meta'}>@{user.username}</span>
                </span>
              ),
              value: `@${user.username}`,
            }))
          )
        })
        .catch(error => {
          console.error(error)
          resolve([])
        })
    })
  }

  searchForCharacter(text) {
    const [username = '', slug = ''] = text.split('/', 2)
    console.debug('searchForCharacter', { username, slug })

    return new Promise(resolve => {
      client
        .query({
          query: Autocomplete.autocompleteCharacter,
          variables: { username, slug },
        })
        .then(({ data, error }) => {
          if (!data) {
            console.error(error)
            resolve([])
          }

          const { autocompleteCharacter: characters } = data
          resolve(
            (characters || []).map(character => ({
              preview: (
                <span className={'markdown-editor--suggestion'}>
                  <span className={'value'}>{character.name}</span>
                  <span className={'meta'}>
                    @{character.username}/{character.slug}
                  </span>
                </span>
              ),
              value: `@${character.username}/${character.slug}`,
            }))
          )
        })
        .catch(error => {
          console.error(error)
          resolve([])
        })
    })
  }

  searchForHashtag(hashtag) {
    console.debug('searchForHashtag', { hashtag })

    return new Promise(resolve => {
      client
        .query({
          query: Autocomplete.autocompleteHashtags,
          variables: { hashtag },
        })
        .then(({ data, error }) => {
          if (!data) {
            console.error(error)
            resolve([])
          }

          const { autocompleteHashtags: hashtags } = data
          resolve(
            (hashtags || []).map(hashtag => ({
              preview: (
                <span className={'markdown-editor--suggestion'}>
                  <span className={'value'}>{hashtag.tag}</span>
                  <span className={'meta'}>{hashtag.count}</span>
                </span>
              ),
              value: `#${hashtag.tag}`,
            }))
          )
        })
        .catch(error => {
          console.error(error)
          resolve([])
        })
    })
  }

  getSuggestions(text, triggeredBy) {
    console.debug({ text, triggeredBy })
    switch (triggeredBy) {
      case ':':
        return Promise.resolve([
          { preview: <p>Emoji not support :(</p>, value: ':cry:' },
        ])
      case '@':
        if (text.match(/\//)) {
          return this.searchForCharacter(text)
        } else {
          return this.searchForUser(text)
        }
      case '#':
        return this.searchForHashtag(text)
    }

    return Promise.resolve([])
  }

  handleTabChange(selectedTab) {
    this.setState({ selectedTab })
  }

  render() {
    const {
      name,
      hashtags,
      emoji,
      content,
      placeholder,
      readOnly,
      onChange,
      slim,
    } = this.props

    let suggestionTriggers = ['@', '$']
    let commands

    if (hashtags) {
      suggestionTriggers.push('#')
    }

    if (emoji) {
      //emoji not support
      //suggestionTriggers.push(':')
    }

    if (slim) {
      commands = [['bold', 'italic', 'strikethrough']]
    } else {
      commands = [['bold', 'italic', 'strikethrough']]
    }

    return (
      <div style={{ position: 'relative' }}>
        {!content && (
          <div
            className={'placeholder text-light'}
            style={{
              position: 'absolute',
              top: '38px',
              padding: '1rem',
              margin: '0',
            }}
          >
            {placeholder}
          </div>
        )}

        <SRM
          value={content}
          onChange={v => onChange(name, v)}
          readOnly={readOnly}
          selectedTab={this.state.selectedTab}
          onTabChange={this.handleTabChange.bind(this)}
          loadSuggestions={this.getSuggestions.bind(this)}
          suggestionTriggerCharacters={suggestionTriggers}
          toolbarCommands={commands}
          classes={{
            preview: 'rich-text card-content',
            suggestionsDropdown: 'z-depth-2',
          }}
          generateMarkdownPreview={markdown =>
            Promise.resolve(sanitize(this.Showdown.makeHtml(markdown)))
          }
        />
      </div>
    )
  }
}

MarkdownEditor.propTypes = {
  name: PropTypes.string,
  onChange: PropTypes.func.isRequired,
  content: PropTypes.string.isRequired,
  readOnly: PropTypes.bool,
  placeholder: PropTypes.string,
  hashtags: PropTypes.bool,
  emoji: PropTypes.bool,
  slim: PropTypes.bool,
}

export default MarkdownEditor
