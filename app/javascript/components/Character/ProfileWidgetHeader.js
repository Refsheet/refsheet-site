import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Icon from 'v1/shared/material/Icon'
import Button from '../Styled/Button'

class ProfileWidgetHeader extends Component {
  constructor(props) {
    super(props)

    this.state = {
      title: props.title,
    }
  }

  handleEditClick(e) {
    e.preventDefault()
    this.props.onEditStart()
  }

  handleCancelClick(e) {
    e.preventDefault()
    this.setState({ title: this.props.title })
    this.props.onEditStop(false)
  }

  handleDeleteClick(e) {
    e.preventDefault()
    this.props.onDelete()
  }

  handleSaveClick(e) {
    e.preventDefault()
    this.props.onSave(this.state.title)
  }

  handleTitleChange(e) {
    e.preventDefault()
    const title = e.target.value
    this.setState({ title })
  }

  handleMove(direction) {
    return e => {
      e.preventDefault()
      this.props.onMove(direction)
    }
  }

  renderLocked() {
    const {
      widgetType,
      title,
      editable,
      lastColumn,
      firstColumn,
      first,
      last,
    } = this.props

    if (editable) {
      return (
        <div className="muted card-header fix-height">
          <div className="right" style={{ opacity: 0.3 }}>
            <a
              href="#"
              onClick={this.handleDeleteClick.bind(this)}
              title={'Delete Widget'}
              className="margin-right--medium"
            >
              <Icon
                className="muted"
                style={{
                  fontSize: '1rem',
                  color: 'rgba(255,255,255,0.1) !important',
                }}
              >
                delete
              </Icon>
            </a>
            <a
              href="#"
              onClick={this.handleEditClick.bind(this)}
              title={'Edit Widget'}
            >
              <Icon
                className="muted"
                style={{
                  fontSize: '1rem',
                  color: 'rgba(255,255,255,0.1) !important',
                }}
              >
                edit
              </Icon>
            </a>
          </div>
          <div className="left" style={{ opacity: 0.3 }}>
            {firstColumn || (
              <a
                href="#"
                onClick={this.handleMove('left').bind(this)}
                title={'Move Left'}
                className="margin-right--medium"
              >
                <Icon
                  className="muted"
                  style={{
                    fontSize: '1rem',
                    color: 'rgba(255,255,255,0.1) !important',
                  }}
                >
                  keyboard_arrow_left
                </Icon>
              </a>
            )}
            {first || (
              <a
                href="#"
                onClick={this.handleMove('up').bind(this)}
                title={'Move Up'}
                className="margin-right--medium"
              >
                <Icon
                  className="muted"
                  style={{
                    fontSize: '1rem',
                    color: 'rgba(255,255,255,0.1) !important',
                  }}
                >
                  keyboard_arrow_up
                </Icon>
              </a>
            )}
            {last || (
              <a
                href="#"
                onClick={this.handleMove('down').bind(this)}
                title={'Move Down'}
                className="margin-right--medium"
              >
                <Icon
                  className="muted"
                  style={{
                    fontSize: '1rem',
                    color: 'rgba(255,255,255,0.1) !important',
                  }}
                >
                  keyboard_arrow_down
                </Icon>
              </a>
            )}
            {lastColumn || (
              <a
                href="#"
                onClick={this.handleMove('right').bind(this)}
                title={'Move Left'}
                className="margin-right--medium"
              >
                <Icon
                  className="muted"
                  style={{
                    fontSize: '1rem',
                    color: 'rgba(255,255,255,0.1) !important',
                  }}
                >
                  keyboard_arrow_right
                </Icon>
              </a>
            )}
          </div>

          <div className="center">{title || widgetType}</div>
        </div>
      )
    } else if (title) {
      return <div className="card-header">{title}</div>
    } else {
      return null
    }
  }

  renderUnlocked() {
    return (
      <div className={'muted card-header fix-height'}>
        <div className="right btn-group">
          <Button
            href="#"
            onClick={this.handleSaveClick.bind(this)}
            disabled={this.props.saving}
          >
            <Icon
              className="muted left"
              style={{
                fontSize: '1rem',
                color: 'rgba(255,255,255,0.1) !important',
              }}
            >
              save
            </Icon>{' '}
            {this.props.saving ? 'Saving...' : 'Save'}
          </Button>
        </div>

        <div className={'center'}>
          <input
            value={this.state.title}
            onChange={this.handleTitleChange.bind(this)}
          />
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
  onEditStop: PropTypes.func.isRequired,
  onMove: PropTypes.func.isRequired,
  onDelete: PropTypes.func.isRequired,
  lastColumn: PropTypes.bool,
  firstColumn: PropTypes.bool,
  first: PropTypes.bool,
  last: PropTypes.bool,
}

export default ProfileWidgetHeader
