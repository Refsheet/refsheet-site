/* global h1 */

import React, { Component } from 'react'
import PropTypes from 'prop-types'
import styled from 'styled-components'
import c from 'classnames'

const InputField = styled.input`
  font: inherit !important;
  margin: 0 !important;
  padding: 0 0.25rem !important;
  border: 1px solid ${props => props.theme.border} !important;
  border-right: none !important;
  display: block;
  flex: 1 1 auto;
  border-top-left-radius: 3px !important;
  border-bottom-left-radius: 3px !important;
  background-color: rgba(0, 0, 0, 0.1) !important;
`

const InputButton = styled.button`
  flex: 0 0 auto;
  display: flex !important;
  flex-direction: column;
  justify-content: center;
  background-color: transparent;

  &:not(.inactive) {
    border: 1px solid ${props => props.theme.border} !important;
    border-left: none !important;
    border-top-right-radius: 3px;
    border-bottom-right-radius: 3px;
    background-color: rgba(0, 0, 0, 0.1) !important;
  }

  &.inactive {
    border: none !important;
    color: ${props => props.theme.textLight} !important;
  }
`

const InputContainer = styled.div`
  display: flex;

  & > .input-value {
    flex: 1 1 auto;
    display: flex;
  }

  & > .input-placeholder {
    padding-right: 0.25rem !important;
  }
`

class EditableHeader extends Component {
  constructor(props) {
    super(props)

    this.state = {
      locked: true,
      value: '',
    }

    this.handleEditClick = this.handleEditClick.bind(this)
    this.handleInputChange = this.handleInputChange.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this)
  }

  unlock() {
    this.setState({
      locked: false,
      value: this.props.children,
    })
  }

  lock() {
    this.setState({
      locked: true,
    })
  }

  submit() {
    this.props.onValueChange && this.props.onValueChange(this.state.value)
    this.lock()
  }

  handleEditClick(e) {
    e.preventDefault()
    this.unlock()
  }

  handleInputChange(e) {
    e.preventDefault()
    this.setState({ value: e.target.value })
  }

  handleSubmit(e) {
    e.preventDefault()
    this.submit()
  }

  render() {
    const ComponentRef = this.props.component || h1

    if (!this.props.editable) {
      return (
        <ComponentRef className={this.props.className}>
          {this.props.children}
        </ComponentRef>
      )
    } else if (this.state.locked) {
      return (
        <div className={'editable-container'}>
          <InputContainer>
            <ComponentRef
              className={c('input-placeholder', this.props.className)}
            >
              {this.props.children || (
                <span className={'muted-color'}>
                  {this.props.default || '?'}
                </span>
              )}
            </ComponentRef>
            <InputButton
              className={'editable-button inactive'}
              title={'edit'}
              onClick={this.handleEditClick}
            >
              <i className={'material-icons'}>edit</i>
            </InputButton>
          </InputContainer>
        </div>
      )
    } else {
      return (
        <form className={'editable-container'} onSubmit={this.handleSubmit}>
          <InputContainer>
            <ComponentRef className={c('input-value', this.props.className)}>
              <InputField
                type={'text'}
                value={this.state.value}
                style={{ font: 'inherit' }}
                onChange={this.handleInputChange}
                autoFocus
              />
            </ComponentRef>
            <InputButton
              className={'editable-button'}
              title={'edit'}
              type={'submit'}
            >
              <i className={'material-icons'}>save</i>
            </InputButton>
          </InputContainer>
        </form>
      )
    }
  }
}

EditableHeader.propTypes = {
  editable: PropTypes.bool,
  onValueChange: PropTypes.func,
  children: PropTypes.string,
}

export default EditableHeader
