import React, { Component } from 'react'
import RTA from '@webscopeio/react-textarea-autocomplete'
import emojiSearch from '@jukben/emoji-search'

class Input extends Component {
  constructor(props) {
    super(props)

    this.textarea = null
  }

  triggers = {
    ":": {
      dataProvider: (token) => {
        console.log({token})
        return emojiSearch(token)
            .slice(0, 10)
            .map(({name, char}) => ({name, char}))
      },
      component: this.renderEmojiItem,
      output: (item, trigger) => item.char
    },

    "@": {
      dataProvider: (token) => {
        console.log({token})
        return [{name: "abc", char: "A"}]
      },
      component: this.renderEmojiItem,
      output: (item, trigger) => item.name
    }
  }

  renderLoading({data}) {
    return <div>Loading...</div>
  }

  renderEmojiItem({ entity: { name, char } }) {
    return <div>{name}: {char}</div>
  }

  render() {
    return (<RTA
      className='chat-input'
      loadingComponent={this.renderLoading}
      innerRef={(textarea) => this.textarea = textarea}
      trigger={this.triggers}
      minChar={0}
      containerStyle={{
        display: 'flex',
        flexGrow: 1
      }}
      style={{
        padding: '0.5rem 1rem',
        border: 'none',
        outline: 'none'
      }}
      {...this.props}
    />)
  }
}

Input.propTypes = {

}

export default Input
