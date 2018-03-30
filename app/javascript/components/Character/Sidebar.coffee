import React, { Component } from 'react'
import M from 'materialize-css'
import PropTypes from 'prop-types'
import styled from 'styled-components'
import TocLink from 'Styled/TocLink'
import { MutedHeader } from 'Styled/Muted'
import { Sticky, StickyContainer } from 'react-sticky'

class Sidebar extends Component
  constructor: (props) ->
    super props
    @instance = null
    @stickyTop = 75

  componentDidMount: ->
    elem = document.querySelectorAll '.profile-scrollspy'
    @instance = M.ScrollSpy.init elem
    console.log "Scrollspy with:", elem

  componentWillUnmount: ->
    @instance?.destroy()

  renderSticky: ({style}) =>
    `<div style={{...style, top: this.stickyTop}}>
      <div className='margin-bottom--large'>
        <MutedHeader>Created By</MutedHeader>
        <Views.Account.UserCard user={this.props.user} smaller />
      </div>

      <ul className='table-of-contents'>
        <li><MutedHeader>Page Sections</MutedHeader></li>
        <li><TocLink to='#top'>Summary</TocLink></li>
        <li><TocLink to='#profile'>About A CHAR</TocLink></li>
        <li><TocLink to='#gallery'>Image Gallery</TocLink></li>
      </ul>
    </div>`

  render: ->
    `<div className='sidebar'>
      <Sticky topOffset={-this.stickyTop}>
        { this.renderSticky }
      </Sticky>
    </div>`

export default Sidebar
