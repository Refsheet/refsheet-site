import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose, { withMutations } from '../../utils/compose'
import updateImage from './updateImage.graphql'
import { Row, Col, Checkbox, Textarea, TextInput } from 'react-materialize'

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

  render() {
    const { image } = this.state

    return (
      <form
        className={'image-details-container'}
        onSubmit={this.handleFormSubmit.bind(this)}
      >
        <div className={'image-details'}>
          <h3>Edit Image</h3>
        </div>

        <div className={'flex-vertical'}>
          <div className={'flex-content padded'}>
            <Row>
              <TextInput
                s={12}
                id={'image_title'}
                name={'title'}
                onChange={this.handleInputChange.bind(this)}
                value={image.title || ''}
                help={"Include #hashtags here. If the last line is just tags, it will not be displayed."}
                label={'Title'}
              />
            </Row>
            <Row>
              <Textarea
                s={12}
                id={'image_caption'}
                name={'caption'}
                onChange={this.handleInputChange.bind(this)}
                value={image.caption || ''}
                label={'Caption'}
              />
            </Row>
            <Row>
              <Col s={6} className={''}>
                <Checkbox
                  onChange={this.handleInputChange.bind(this)}
                  checked={image.nsfw}
                  id={'image_nsfw'}
                  value="nsfw"
                  label="NSFW"
                />
              </Col>

              <Col s={6} className={''}>
                <Checkbox
                  onChange={this.handleInputChange.bind(this)}
                  checked={image.hidden}
                  id={'image_hidden'}
                  value="hidden"
                  label={'Hidden'}
                />
              </Col>
            </Row>
          </div>

          <div className={'flex-fixed padded'}>
            <button type={'submit'} className={'btn btn-primary right'}>
              Save
            </button>
            <a
              href={'#'}
              className={'btn btn-secondary'}
              onClick={this.handleCancelClick.bind(this)}
            >
              Cancel
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
    nsfw: PropTypes.boolean,
  }).isRequired,
  onCancel: PropTypes.func,
  onSave: PropTypes.func,
}

export default compose(withMutations({ updateImage }))(ImageEditForm)
