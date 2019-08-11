import React, { Component } from 'react'
import PropTypes from 'prop-types'

class IdentitySelect extends Component {
  constructor(props) {
    super(props)

    this.state = {
      identityModalOpen: false
    }
  }

  handleModalOpen(e) {
    e.preventDefault()
    console.log("Changing identity...")
    this.setState({identityModalOpen: true})
  }

  handleModalDone(e) {
    this.setState({identityModalOpen: false})
  }

  renderModal() {
    if (!this.state.identityModalOpen) {
      return null
    }

    return (
      <Modal
        autoOpen
        id='select-identity'
        title={'Change Identity'}
        onClose={this.handleModalDone.bind(this)}
      >
        <ul className={'collection-list'}>
          <li className={'collection-item'}>User: Admin Mc Adminpants</li>
          <li className={'collection-item'}>Raven</li>
        </ul>
      </Modal>
    )
  }

  render() {
    return (
      <div className={'identity-select truncate'} style={{lineHeight: '36px', verticalAlign: 'middle'}}>
        <span className={'muted'} style={{lineHeight: '36px', verticalAlign: 'middle'}}>As: </span>
        <a href={'#select-identity'} onClick={this.handleModalOpen.bind(this)} title={'Change Identity'} style={{lineHeight: '36px', verticalAlign: 'middle'}}>Admin Mc Adminpants</a>
        { this.renderModal() }
      </div>
    )
  }
}

IdentitySelect.propTypes = {}

export default IdentitySelect