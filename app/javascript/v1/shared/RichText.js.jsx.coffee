import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import sanitize from 'sanitize'

export default RichText = createReactClass
  getInitialState: ->
    edit: false
    markup: @props.markup
    error: null

  handleEditStart: (e) ->
    if @props.onChange?
      @setState edit: true

  handleEditStop: (e) ->
    @setState edit: false, markup: @props.markup

  handleMarkupChange: (e) ->
    @setState markup: e.target.value

  handleSubmit: (e) ->
    @props.onChange @state.markup, =>
      @setState edit: false,
    (error) =>
      @setState error: error
      console.log error
    e.preventDefault()

  componentDidUpdate: ->
    if (@refs.input)
      Materialize.textareaAutoResize(@refs.input)

  isEmpty: (text) ->
    !text || text == '' || text.match(/^\s*$/)

  render: ->
    if @props.onChange?
      editable = true

    if @state.edit
      `<div className={ 'rich-text editing ' + this.props.className }>
          <textarea ref='input' className='materialize-textarea' onChange={ this.handleMarkupChange } value={ this.state.markup } autoFocus />
          <button type='submit' className='btn right waves-effect waves-light' onClick={ this.handleSubmit }>Save Changes</button>
          <a className='btn grey darken-3' onClick={ this.handleEditStop }>
              <i className='material-icons'>cancel</i>
          </a>
      </div>`

    else if !@isEmpty(this.state.markup)
      `<div className={ 'rich-text ' + this.props.className }>
          { editable &&
              <a className='edit-button right' onClick={ this.handleEditStart }>
                  <i className='material-icons'>edit</i>
              </a>
          }

          <div dangerouslySetInnerHTML={{ __html: sanitize(this.props.content) }} />
      </div>`

    else
      if @props.onChange?
        placeholderText = 'Click to set text...'
      else
        placeholderText = @props.placeholder || 'No content.'

      `<div className={ 'rich-text empty ' + this.props.className } onClick={ this.handleEditStart }>
          { editable &&
              <a className='edit-button right' onClick={ this.handleEditStart }>
                  <i className='material-icons'>edit</i>
              </a>
          }

          <div>{ placeholderText }</div>
      </div>`
