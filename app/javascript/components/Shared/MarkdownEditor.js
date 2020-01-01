import React, { Component } from 'react'
import c from 'classnames'
import MarkdownInput from '@opuscapita/react-markdown'
import Autocomplete from './autocomplete.graphql'
import client from 'ApplicationService'

class MarkdownEditor extends Component {
  searchForUser(username) {
    return new Promise(resolve => {
      client
        .query({ query: Autocomplete.searchForUser, variables: { username } })
        .then(({ data, error }) => {
          if (!data) {
            console.error(error)
            resolve([])
          }

          const { searchForUser: users } = data
          resolve(users || [])
        })
        .catch(error => {
          console.error(error)
          resolve([])
        })
    })
  }

  searchForCharacter(username, slug) {
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
          resolve(characters || [])
        })
        .catch(error => {
          console.error(error)
          resolve([])
        })
    })
  }

  searchForHashtag(hashtag) {
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
          resolve(hashtags || [])
        })
        .catch(error => {
          console.error(error)
          resolve([])
        })
    })
  }

  usernameAutoComplete() {
    const _this = this

    return {
      specialCharacter: '@',
      termRegex: /^@(\w*)$/,
      searchItems(term) {
        return _this.searchForUser(term.substring(1))
      },
      markdownText(item) {
        return '@' + item.username
      },
      renderItem: ({ item, isSelected }) => (
        <div
          className={c('react-markdown--autocomplete-widget__item user-token', {
            selected: isSelected,
          })}
        >
          <span className={'name'}>{item.name}</span>
          <span className={'username'}>@{item.username}</span>
        </div>
      ),
    }
  }

  characterAutoComplete() {
    const _this = this

    return {
      specialCharacter: '@',
      termRegex: /^@(\w*)\/(\w*)$/,
      searchItems(term) {
        const [username, slug] = term.split('/')
        return _this.searchForCharacter(username.substring(1), slug)
      },
      markdownText(item) {
        return '@' + item.username + '/' + item.slug
      },
      renderItem: ({ item, isSelected }) => (
        <div
          className={c(
            'react-markdown--autocomplete-widget__item user-token character',
            { selected: isSelected }
          )}
        >
          <span className={'name'}>{item.name}</span>
          <span className={'username'}>
            @{item.username}/{item.slug}
          </span>
        </div>
      ),
    }
  }

  hashtagAutoComplete() {
    const _this = this

    return {
      specialCharacter: '#',
      termRegex: /^#(\w*)$/,
      searchItems(term) {
        return _this.searchForHashtag(term.substring(1))
      },
      markdownText(item) {
        return '#' + item.tag
      },
      renderItem: ({ item, isSelected }) => (
        <div
          className={c(
            'react-markdown--autocomplete-widget__item user-token character',
            { selected: isSelected }
          )}
        >
          <span className={'name'}>#{item.tag}</span>
          <span className={'username right'}>{item.count || 0}</span>
        </div>
      ),
    }
  }

  render() {
    const { content, onChange, hashtags } = this.props

    let extensions = [
      this.usernameAutoComplete.bind(this)(),
      this.characterAutoComplete.bind(this)(),
    ]

    if (hashtags) {
      extensions.push(this.hashtagAutoComplete.bind(this)())
    }

    return (
      <MarkdownInput
        value={content || 'Enter text here...'}
        showFullScreenButton={false}
        onChange={onChange}
        autoFocus={true}
        extensions={extensions}
      />
    )
  }
}

export default MarkdownEditor
