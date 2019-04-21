import React, { Component } from 'react'
import PropTypes from 'prop-types'

class ProfileWidgetHeader extends Component {
  constructor(props) {
    super(props)

    this.state = {
      title: props.title
    }
  }

  handleEditClick(e) {
    e.preventDefault()
    this.props.onEditStart()
  }

  handleCancelClick(e) {
    e.preventDefault()
    this.setState({title: this.props.title})
    this.props.onEditStop()
  }

  handleSaveClick(e) {
    e.preventDefault()
    this.props.onSave(this.state.title)
  }

  handleTitleChange(e) {
    e.preventDefault()
    const title = e.target.value
    this.setState({title})
  }

  renderLocked() {
    const {widgetType, title, editable} = this.props

    if (editable) {
      return (
        <div className='muted card-header fix-height'>
          <div className='right' style={{opacity: 0.3}}>
            {/*<a href='#' className='margin-right--medium'><Icon className='muted' style={{fontSize: '1rem', color: 'rgba(255,255,255,0.1) !important'}}>delete</Icon></a>*/}
            <a href='#' onClick={this.handleEditClick.bind(this)}><Icon className='muted' style={{fontSize: '1rem', color: 'rgba(255,255,255,0.1) !important'}}>edit</Icon></a>
          </div>
          <div className='left' style={{opacity: 0.3}}>
            {/*<a href='#' className='margin-right--medium'><Icon className='muted' style={{fontSize: '1rem', color: 'rgba(255,255,255,0.1) !important'}}>reorder</Icon></a>*/}
            {/*<a href='#'><Icon className='muted' style={{fontSize: '1rem', color: 'rgba(255,255,255,0.1) !important'}}>content_copy</Icon></a>*/}
          </div>

          <div className='center'>
            { title || widgetType }
          </div>
        </div>
      );

    } else if (title) {
      return (
        <div className='card-header'>
          { title }
        </div>
      );

    } else {
      return null;
    }
  }

  renderUnlocked() {
    const {widgetType, title} = this.props

    return (
      <div className={'muted card-header fix-height'}>
        <div className='right btn-group'>
          <a href='#' className={'btn'} onClick={this.handleSaveClick.bind(this)}>
            <Icon className='muted left' style={{fontSize: '1rem', color: 'rgba(255,255,255,0.1) !important'}}>save</Icon> Save
          </a>
        </div>

        <div className={'center'}>
          <input value={this.state.title} onChange={this.handleTitleChange.bind(this)} />
        </div>
      </div>
    )
  }

  render() {
    if (this.props.editing) return this.renderUnlocked()
    else return this.renderLocked()
  }
}

ProfileWidgetHeader.propTypes = {
  editable: PropTypes.bool,
  editing: PropTypes.bool,
  onEditStart: PropTypes.func.isRequired,
  onSave: PropTypes.func.isRequired,
  onEditStop: PropTypes.func.isRequired
}

export default ProfileWidgetHeader