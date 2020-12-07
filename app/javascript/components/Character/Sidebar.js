import React, { Component } from 'react'
import M from 'materialize-css'
import PropTypes from 'prop-types'
import TocLink from 'Styled/TocLink'
import { Icon } from 'react-materialize'
import { MutedHeader } from 'Styled/Muted'
import { SidebarLink } from 'Styled/Sidebar'
import { Sticky, StickyContainer } from 'react-sticky'
import UserCard from 'User/UserCard'
import { connect } from 'react-redux'
import ProfileConvertButton from './ProfileConvertButton'

class Sidebar extends Component {
  constructor(props) {
    super(props)

    this.renderSticky = this.renderSticky.bind(this)
    this.toggleEditable = this.toggleEditable.bind(this)

    this.instance = null
    this.stickyTop = 75
  }

  handleSettingsClick(e) {
    e.preventDefault()
    this.props.onSettingsClick && this.props.onSettingsClick()
  }

  handleColorClick(e) {
    e.preventDefault()
    this.props.onColorClick && this.props.onColorClick()
  }

  handleRevisionsClick(e) {
    e.preventDefault()
    this.props.onRevisionsClick && this.props.onRevisionsClick()
  }

  componentDidMount() {
    const elem = document.querySelectorAll('.profile-scrollspy')
    this.instance = M.ScrollSpy.init(elem)
  }

  componentDidUpdate() {
    const elem = document.querySelectorAll('.profile-scrollspy')
    this.instance = M.ScrollSpy.init(elem)
  }

  componentWillUnmount() {
    this.instance && this.instance.destroy && this.instance.destroy()
  }

  renderSections() {
    const sections = this.props.profileSections
      .filter(s => s.title)
      .sort((a, b) => (a.row_order || 0) - (b.row_order || 0))

    return sections.map(s => (
      <li key={s.id}>
        <TocLink to={`#s:${s.id}`}>{s.title}</TocLink>
      </li>
    ))
  }

  toggleEditable(e) {
    e.preventDefault()
    this.props.onEditableChange(!this.props.editable)
  }

  renderSticky({ style }) {
    const canEdit = this.props.canEdit
    const conversionRequired = this.props.characterVersion === 1

    return (
      <div style={{ ...style, top: this.stickyTop }}>
        <div className="margin-bottom--large">
          <MutedHeader>Created By</MutedHeader>
          <UserCard user={this.props.user} smaller />
        </div>

        {canEdit && (
          <div className={'margin-bottom--large'}>
            <MutedHeader className={'margin-bottom--small'}>Manage</MutedHeader>
            {conversionRequired && (
              <div className={'notice'}>
                <div className={'strong red-text text-darken-1'}>
                  <Icon className={'left red-text text-darken-1'}>warning</Icon>
                  <strong>Profile Conversion Required!</strong>
                </div>
                <br className={'clearfix'} />
                <p className={'margin-top--none'}>
                  This character profile must be converted to use the new
                  Profile layout. This will cause the old profile view to become
                  out of sync.
                </p>
                <ProfileConvertButton
                  id={this.props.characterId}
                  onConvert={this.props.refetch}
                />
              </div>
            )}

            {(!conversionRequired && this.props.editable) || (
              <SidebarLink to="#edit" onClick={this.toggleEditable} icon="edit">
                Edit
              </SidebarLink>
            )}
            {!conversionRequired && this.props.editable && (
              <SidebarLink to="#edit" onClick={this.toggleEditable} icon="lock">
                Stop Editing
              </SidebarLink>
            )}
            <SidebarLink
              to="#settings"
              icon="settings"
              onClick={this.handleSettingsClick.bind(this)}
            >
              Settings
            </SidebarLink>
            <SidebarLink
              to="#color"
              icon="palette"
              onClick={this.handleColorClick.bind(this)}
            >
              Color Scheme
            </SidebarLink>
            <SidebarLink
              to={'#revisions'}
              icon={'history'}
              onClick={this.handleRevisionsClick.bind(this)}
            >
              Revisions
            </SidebarLink>
            {/*<SidebarLink to='#' icon='archive'>Archive</SidebarLink>*/}
          </div>
        )}

        <ul className="table-of-contents">
          <li key={'-page-sections'}>
            <MutedHeader>Page Sections</MutedHeader>
          </li>
          <li key={'-summary'}>
            <TocLink to="#top">Summary</TocLink>
          </li>
          {this.renderSections()}
          <li key={'-gallery'}>
            <TocLink to="#gallery">Image Gallery</TocLink>
          </li>
        </ul>
      </div>
    )
  }

  render() {
    return (
      <div className="sidebar">
        <Sticky topOffset={-this.stickyTop}>{this.renderSticky}</Sticky>
      </div>
    )
  }
}

Sidebar.propTypes = {
  user: PropTypes.object.isRequired,
  profileSections: PropTypes.array,
  onEditableChange: PropTypes.func.isRequired,
  editable: PropTypes.bool,
  characterVersion: PropTypes.number,
  refetch: PropTypes.func,
  onColorClick: PropTypes.func,
  onSettingsClick: PropTypes.func,
  canEdit: PropTypes.bool,
}

const mapStateToProps = state => ({
  currentUser: state.currentUser,
})

export default connect(mapStateToProps)(Sidebar)
