import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose, { withMutations } from '../../utils/compose'
import updateImage from './updateImage.graphql'
import {
  Row,
  Col,
  Checkbox,
  Textarea,
  TextInput,
  Select,
} from 'react-materialize'
import { withTranslation } from 'react-i18next'
import MarkdownEditor from '../Shared/MarkdownEditor'

class ImageEditForm extends Component {
  constructor(props) {
    super(props)

    this.state = {
      image: this.props.image,
    }
  }

  handleFormSubmit(e) {
    e.preventDefault()
    this.props
      .updateImage({
        variables: {
          ...this.state.image,
        },
      })
      .then(({ data, errors }) => {
        if (errors) {
          console.error(errors)
        } else {
          if (this.props.onSave) {
            this.props.onSave(data.updateImage)
          }
        }
      })
      .catch(console.error)
  }

  handleCancelClick(e) {
    e.preventDefault()
    if (this.props.onCancel) {
      this.props.onCancel()
    }
  }

  handleInputChange(e) {
    let image = { ...this.state.image }
    let value = e.target.value
    let name = e.target.name

    if (e.target.type === 'checkbox') {
      value = e.target.checked
      name = e.target.value
    }

    image[name] = value
    this.setState({ image })
  }

  handleCaptionChange(name, caption) {
    const image = { ...this.state.image, caption }
    this.setState({ image })
  }

  render() {
    const { t } = this.props
    const { image } = this.state

    const gravities = [
      'NorthWest',
      'North',
      'NorthEast',
      'West',
      'Center',
      'East',
      'SouthWest',
      'South',
      'SouthEast',
    ]

    return (
      <form
        className={'image-details-container'}
        onSubmit={this.handleFormSubmit.bind(this)}
      >
        <div className={'image-details'}>
          <h3>{t('actions.edit_image', 'Edit Image')}</h3>
        </div>

        <div className={'flex-vertical'}>
          <div className={'flex-content overflow padded'}>
            <Row>
              <TextInput
                s={12}
                id={'image_title'}
                name={'title'}
                onChange={this.handleInputChange.bind(this)}
                value={image.title || ''}
                label={t('labels.title', 'Title')}
              />
            </Row>

            <div className={'markdown-caption'}>
              {t('labels.caption', 'Caption')}
            </div>
            <MarkdownEditor
              key={'image_caption'}
              name={'caption'}
              content={image.caption || ''}
              hashtags
              slim
              onChange={this.handleCaptionChange.bind(this)}
            />

            <Row>
              <TextInput
                s={12}
                id={'image_source_url'}
                name={'source_url'}
                onChange={this.handleInputChange.bind(this)}
                value={image.source_url || ''}
                label={t('labels.source_url', 'Source URL')}
              />
            </Row>
            <Row>
              <Col s={6} className={''}>
                <Checkbox
                  onChange={this.handleInputChange.bind(this)}
                  checked={image.nsfw}
                  id={'image_nsfw'}
                  value="nsfw"
                  label={t('labels.nsfw', 'NSFW')}
                />
              </Col>

              <Col s={6} className={''}>
                <Checkbox
                  onChange={this.handleInputChange.bind(this)}
                  checked={image.hidden}
                  id={'image_hidden'}
                  value="hidden"
                  label={t('labels.hidden', 'Hidden')}
                />
              </Col>
            </Row>
            <Row>
              <Col s={6}>
                <Checkbox
                  onChange={this.handleInputChange.bind(this)}
                  checked={image.watermark}
                  id={'image_watermark'}
                  value={'watermark'}
                  label={t('labels.watermark', 'Watermark')}
                />
              </Col>
            </Row>
            <Row>
              <Select
                s={12}
                name={'gravity'}
                id={'image_gravity'}
                label={t('labels.gravity', 'Crop Priority')}
                onChange={this.handleInputChange.bind(this)}
                value={image.gravity}
              >
                <option key={'null'} value={''}>
                  {t('image_gravity.default', 'Default')}
                </option>

                {gravities.map(gravity => (
                  <option key={gravity} value={gravity}>
                    {t(`image_gravity.${gravity}`, gravity)}
                  </option>
                ))}
              </Select>
            </Row>
          </div>

          <div className={'flex-fixed padded'}>
            <button type={'submit'} className={'btn btn-primary right'}>
              {t('actions.save', 'Save')}
            </button>
            <a
              href={'#'}
              className={'btn btn-secondary'}
              onClick={this.handleCancelClick.bind(this)}
            >
              {t('actions.cancel', 'Cancel')}
            </a>
          </div>
        </div>
      </form>
    )
  }
}

ImageEditForm.propTypes = {
  image: PropTypes.shape({
    name: PropTypes.string,
    caption: PropTypes.string,
    nsfw: PropTypes.bool,
  }).isRequired,
  onCancel: PropTypes.func,
  onSave: PropTypes.func,
}

export default compose(
  withTranslation('common'),
  withMutations({ updateImage })
)(ImageEditForm)
