import React, { Component } from 'react'
import c from 'classnames'
import ReactMde from 'react-mde'
import * as Showdown from 'showdown'
import Autocomplete from './autocomplete.graphql'
import client from 'ApplicationService'
import './react-mde-overrides.scss'
import styled from "styled-components";

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
      tasklists: true
    })
  }

  searchForUser(username) {
    console.log("searchForUser", {username})
    return new Promise(resolve => {
      client
        .query({ query: Autocomplete.searchForUser, variables: { username } })
        .then(({ data, error }) => {
          if (!data) {
            console.error(error)
            resolve([])
          }

          const { searchForUser: users } = data

          resolve((users || []).map(user => ({
            preview: <span className={'markdown-editor--suggestion'}>
              <span className={'value'}>{ user.name }</span>
              <span className={'meta'}>@{ user.username }</span>
            </span>,
            value: `@${user.username}`
          })))
        })
        .catch(error => {
          console.error(error)
          resolve([])
        })
    })
  }

  searchForCharacter(text) {
    const [ username = "", slug = "" ] = text.split('/', 2)
    console.log("searchForCharacter", {username, slug})

    return new Promise(resolve => {
      client
        .query({
          query: Autocomplete.searchForCharacter,
          variables: { username, slug },
        })
        .then(({ data, error }) => {
          if (!data) {
            console.error(error)
            resolve([])
          }

          const { searchForCharacter: characters } = data
          resolve((characters || []).map(character => ({
            preview: <span className={'markdown-editor--suggestion'}>
              <span className={'value'}>{ character.name }</span>
              <span className={'meta'}>@{ character.username }/{character.slug}</span>
            </span>,
            value: `@${character.username}/${character.slug}`
          })))
        })
        .catch(error => {
          console.error(error)
          resolve([])
        })
    })
  }

  searchForHashtag(hashtag) {
    console.log("searchForHashtag", {hashtag})

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
          resolve((hashtags || []).map(hashtag => ({
            preview: <span className={'markdown-editor--suggestion'}>
              <span className={'value'}>{ hashtag.tag }</span>
              <span className={'meta'}>{ hashtag.count }</span>
            </span>,
            value: `#${hashtag.tag}`
          })))
        })
        .catch(error => {
          console.error(error)
          resolve([])
        })
    })
  }

  getSuggestions(text, triggeredBy) {
    console.log({text, triggeredBy})
    switch (triggeredBy) {
      case ":":
        return Promise.resolve([{preview: <p>Emoji not support :(</p>, value: ":cry:"}])
      case "@":
        if (text.match(/\//)) {
          return this.searchForCharacter(text)
        } else {
          return this.searchForUser(text)
        }
      case "#":
        return this.searchForHashtag(text)
    }

    return Promise.resolve([])
  }

  handleTabChange(selectedTab) {
    this.setState({selectedTab})
  }

  render() {
    const { hashtags, emoji, content, placeholder, readOnly, onChange } = this.props

    let suggestionTriggers = ['@', '$']

    if (hashtags) {
      suggestionTriggers.push('#')
    }

    if (emoji) {
      suggestionTriggers.push(':')
    }

    return (
      <div style={{ position: 'relative' }}>
        <SRM
          value={content}
          onChange={onChange}
          readOnly={readOnly}
          placeholder={placeholder}
          selectedTab={this.state.selectedTab}
          onTabChange={this.handleTabChange.bind(this)}
          loadSuggestions={this.getSuggestions.bind(this)}
          suggestionTriggerCharacters={suggestionTriggers}
          classes={{
            preview: 'rich-text card-content',
            suggestionsDropdown: 'z-depth-2'
          }}
          generateMarkdownPreview={ markdown => Promise.resolve(this.Showdown.makeHtml(markdown)) }
        />
      </div>
    )
  }
}

export default MarkdownEditor
