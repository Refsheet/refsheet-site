import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Icon, Dropdown, Divider } from 'react-materialize'
import { closeLightbox } from '../../actions'
import compose, { withMutations } from '../../utils/compose'
import { withTranslation } from 'react-i18next'
import { connect } from 'react-redux'
import deleteMedia from './deleteMedia.graphql'
import { getCharacterProfile as gcp } from 'queries/getCharacterProfile.graphql'
import M from 'materialize-css'

import Modal from 'v1/shared/Modal'
import CacheUtils from '../../utils/CacheUtils'

class ImageActions extends Component {
  constructor(props) {
    super(props)

    this.state = {
      deleteModalOpen: false,
    }
  }

  handleEditClick(e) {
    e.preventDefault()
    this.props.onEditClick && this.props.onEditClick()
  }

  handleDownloadClick(e) {
    e.preventDefault()

    window.open(this.props.downloadLink, '_blank')
  }

  handleDeleteConfirm(e) {
    e.preventDefault()

    this.props
      .deleteMedia({
        variables: {
          mediaId: this.props.mediaId,
        },
        update: CacheUtils.deleteMedia,
      })
      .then(({ data, errors }) => {
        if (!errors || errors.length === 0) {
          this.props.closeLightbox()
          M.toast({
            html: 'Image deleted.',
            displayLength: 3000,
            classes: 'green',
          })
        } else {
          console.error(errors)
          M.toast({
            html: 'Something went wrong.',
            displayLength: 3000,
            classes: 'red',
          })
        }
      })
      .catch(console.error)
  }

  openModal(name) {
    return e => {
      e && e.preventDefault && e.preventDefault()
      let state = {}
      state[name + 'ModalOpen'] = true
      this.setState(state)
    }
  }

  closeModal(name) {
    return e => {
      e && e.preventDefault && e.preventDefault()
      let state = {}
      state[name + 'ModalOpen'] = false
      this.setState(state)
    }
  }

  render() {
    const { downloadLink, t } = this.props

    const { deleteModalOpen } = this.state

    return (
      <div className={'image-actions'}>
        {deleteModalOpen && (
          <Modal
            title={'Confirm Delete'}
            autoOpen
            onClose={this.closeModal('delete').bind(this)}
          >
            <p>
              {t(
                'prompts.delete_confirm',
                'Are you sure you want to delete this image?'
              )}
            </p>
            <p>
              <a
                onClick={this.handleDeleteConfirm.bind(this)}
                href={'#'}
                className={'red-text'}
              >
                {t('actions.delete_confirm', 'Yes, Delete Image')}
              </a>
            </p>
          </Modal>
        )}

        <div className={'image-action-menu'}>
          <a href={'#edit-image'} onClick={this.handleEditClick.bind(this)}>
            <Icon>edit</Icon>
          </a>
        </div>

        <div className={'image-action-menu'}>
          <Dropdown
            options={{
              alignment: 'right',
              constrainWidth: false,
              closeOnClick: true,
            }}
            trigger={
              <a href={'#image-options'}>
                <Icon>more_vert</Icon>
              </a>
            }
          >
            {/*<a href={'#'}>Set as Cover Image</a>*/}
            {/*<a href={'#'}>Set as Profile Image</a>*/}
            {/*<Divider />*/}
            {/*<a href={'#'}>*/}
            {/*  <Icon className={'left'}>crop</Icon>*/}
            {/*  <span>Cropping...</span>*/}
            {/*</a>*/}
            {/*<Divider />*/}
            <a
              href={downloadLink}
              target={'_blank'}
              rel="noopener noreferrer"
              onClick={this.handleDownloadClick.bind(this)}
            >
              <Icon className={'left'}>file_download</Icon>
              <span>Download</span>
            </a>
            {/*<a href={'#'}>*/}
            {/*  <Icon className={'left'}>forward</Icon>*/}
            {/*  <span>Transfer To...</span>*/}
            {/*</a>*/}
            <a href={'#'} onClick={this.openModal('delete').bind(this)}>
              <Icon className={'left'}>delete</Icon>
              <span>Delete...</span>
            </a>
          </Dropdown>
        </div>
      </div>
    )
  }
}

ImageActions.propTypes = {
  onEditClick: PropTypes.func,
  downloadLink: PropTypes.string.isRequired,
  mediaId: PropTypes.oneOfType([PropTypes.string, PropTypes.number]).isRequired,
}

const mapDispatchToProps = {
  closeLightbox,
}

export default compose(
  withTranslation('common'),
  connect(undefined, mapDispatchToProps),
  withMutations({ deleteMedia })
)(ImageActions)
