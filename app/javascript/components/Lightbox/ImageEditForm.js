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
    console.log(this.state.image)
  }

  handleCancelClick(e) {
    e.preventDefault()
    console.log('Good bye.')
  }

  handleInputChange(e) {
    e.preventDefault()

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

    console.log({image})

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
}

export default compose(withMutations({ updateImage }))(ImageEditForm)
