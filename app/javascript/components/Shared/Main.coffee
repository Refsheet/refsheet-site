import React, { Component } from 'react'
import PropTypes from 'prop-types'

export default class Main extends Component
  @propTypes:
    style: PropTypes.object
    className: PropTypes.string
    bodyClassName: PropTypes.string
    id: PropTypes.string
    title: PropTypes.oneOfType([
      PropTypes.string
      PropTypes.array
    ])


  constructor: (props) ->
    super props

  _updateTitle: (title) ->
    titles = []
    titles.push title
    titles.push 'Refsheet.net'
    document.title = [].concat.apply([], titles).join ' - '

  componentWillMount: ->
    if @props.title
      @_updateTitle @props.title

#    document.body.addClass @props.bodyClassName

  componentWillReceiveProps: (newProps) ->
    if newProps.title
      @_updateTitle newProps.title

#    if newProps.bodyClassName != @props.bodyClassName
#      document.body.removeClass @props.bodyClassName
#      document.body.addClass newProps.bodyClassName
#
#  componentWillUnmount: ->
#    document.body.removeClass @props.bodyClassName


  render: ->
    style = @props.style || {}
    classNames = [this.props.className]
    classNames.push 'main-flex' if this.props.flex

    `<main style={ style } id={ this.props.id } className={ classNames.join(' ') }>
      { this.props.children }
    </main>`
