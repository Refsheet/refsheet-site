import React, { Component } from 'react'
import PropTypes from 'prop-types'
import MarkdownInput from '@opuscapita/react-markdown'
import c from 'classnames'

class RichTextWidget extends Component {
  constructor(props) {
    super(props)
  }

  handleMarkdownChange(content) {
    this.props.onChange({content})
  }

  render() {
    const {contentHtml} = this.props

    if (this.props.editing) {
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
        <div className={'rich-text-widget editing'}>
          <MarkdownInput
            value={this.props.content || 'Enter text here...'}
            showFullScreenButton={false}
            onChange={this.handleMarkdownChange.bind(this)}
            onBlur={() => console.log("md blur")}
            autoFocus={true}
            extensions={[
              usernameAutoComplete,
              characterAutoComplete
            ]}
          />
        </div>
      )
    }

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
  contentHtml: PropTypes.string,
  editing: PropTypes.bool,
  onChange: PropTypes.func.isRequired
}

export default RichTextWidget