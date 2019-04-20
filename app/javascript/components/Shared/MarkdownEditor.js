import React from 'react'
import c from "classnames";
import MarkdownInput from "@opuscapita/react-markdown";

const MarkdownEditor = ({content, onChange}) => {
  const usernameAutoComplete = {
    specialCharacter: '@',
    termRegex: /^@(\w*)$/,
    searchItems(term) {
      const items = [
        {username: 'mauabata', displayName: 'Mau Abata'},
        {username: 'inkmaven', displayName: 'Inkmaven'}
      ];

      return new Promise(resolve => {
        const filtered = items.filter(({ username }) =>
          username.indexOf(term.substring(1)) === 0
        );

        setTimeout(_ => resolve(filtered), 300);
      })
    },
    markdownText(item) {
      return '@' + item.username;
    },
    renderItem: ({ item, isSelected }) => (
      <div className={c('react-markdown--autocomplete-widget__item user-token', {selected: isSelected})}>
        <span className={'name'}>{ item.displayName }</span>
        <span className={'username'}>@{item.username}</span>
      </div>
    )
  }

  const characterAutoComplete = {
    specialCharacter: '@',
    termRegex: /^@(\w*)\/(\w*)$/,
    searchItems(term) {
      const items = [
        {username: 'mauabata', displayName: 'Alice Nikova', slug: 'alice'},
        {username: 'inkmaven', displayName: 'Ink', slug: 'ink'}
      ];

      const search = term.split('/')[1]
      console.log({search})

      return new Promise(resolve => {
        const filtered = items.filter(({ slug }) =>
          slug.indexOf(search) === 0
        );

        setTimeout(_ => resolve(filtered), 300);
      })
    },
    markdownText(item) {
      return '@' + item.username + '/' + item.slug;
    },
    renderItem: ({ item, isSelected }) => (
      <div className={c('react-markdown--autocomplete-widget__item user-token character', {selected: isSelected})}>
        <span className={'name'}>{ item.displayName }</span>
        <span className={'username'}>@{item.username}/{item.slug}</span>
      </div>
    )
  }

  return (
    <MarkdownInput
      value={content || 'Enter text here...'}
      showFullScreenButton={false}
      onChange={onChange}
      autoFocus={true}
      extensions={[
        usernameAutoComplete,
        characterAutoComplete
      ]}
    />
  )
}

export default MarkdownEditor