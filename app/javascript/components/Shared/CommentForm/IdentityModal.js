import React, { Component } from 'react'
import PropTypes from 'prop-types'
import {Query} from "react-apollo";
import {withNamespaces} from "react-i18next";
import SearchForCharacter from 'ActivityFeed/searchForCharacter.graphql'

class IdentityModal extends Component {
  constructor(props) {
    super(props)

    this.state = {
      query: "",
      queryInput: ""
    }
  }

  handleModalDone(e) {
    this.props.onClose()
  }

  handleCharacterSelect(character) {
    return (e) => {
      e.preventDefault()
      this.props.onCharacterSelect(character)
    }
  }

  renderCharacterList(characters) {
    return (
      <ul className={'collection margin--none'}>
        { characters.map((character) => (
          <li key={character.id} className={'collection-item avatar'}>
            <img src={character.profile_image.url.thumbnail} alt={character.name} className={'circle'} />
            <a className='title' href={character.path} onClick={this.handleCharacterSelect(character).bind(this)}>{ character.name }</a>
            <p>{ character.species }</p>
          </li>
        )) }
      </ul>
    )
  }

  handleQueryChange(e) {
    e.preventDefault()
    this.setState({queryInput: e.target.value})
  }

  handleSearch(e) {
    e.preventDefault()
    this.setState({query: this.state.queryInput})
  }

  render() {
    const { t } = this.props

    return (
      <Modal
        autoOpen
        noContainer
        id='select-identity'
        title={t('identity.change', 'Change Identity')}
        onClose={this.handleModalDone.bind(this)}
      >
        <form className={'modal-inline-form'} onSubmit={this.handleSearch.bind(this)}>
          <input
            type={'text'}
            className={'block'}
            name={'query'}
            placeholder={t('identity.search', 'Search for Character...')}
            onChange={this.handleQueryChange.bind(this)}
            value={this.state.queryInput}
          />
          <button type={'submit'} className={'btn'}>
            <i className={'material-icons'}>search</i>
          </button>
        </form>

        <Query query={SearchForCharacter} variables={{ slug: this.state.query, username: "me" }}>
          { ({data, loading, errors}) => {
            if (loading) {
              return <div className='caption center modal-content'>{ t('status.loading', 'Loading...') }</div>
            } else if (errors) {
              return <div className='caption center error red-text modal-content'>{ "" + errors }</div>
            } else {
              return this.renderCharacterList(data.searchForCharacter)
            }
          }}
        </Query>

        <div className={'modal-footer right-align'}>
          <button className={'btn'} onClick={this.handleCharacterSelect(null).bind(this)}>
            { t('identity.as-self', 'Post As Yourself') }
          </button>
        </div>
      </Modal>
    )
  }
}

IdentityModal.propTypes = {
  onClose: PropTypes.func.isRequired,
  onCharacterSelect: PropTypes.func.isRequired
}

export default withNamespaces('common')(IdentityModal)