import React, { Component } from 'react'
import PropTypes from 'prop-types'

import {
  Row,
  Input,
  Button
} from 'react-materialize'

class UploadForm extends Component {
  constructor (props) {
    super(props)

    this.handleChange = this.handleChange.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this)
  }

  handleChange (e) {
    const {
      image,
      onChange
    } = this.props

    let value = e.target.value

    if (e.target.type === 'checkbox') {
      value = e.target.checked
      console.log("Checkbox changed to: " + value)
    }

    if (!onChange) return
    image[ e.target.name ] = value
    onChange(image)
  }

  handleClear(e) {
    e.preventDefault()
    console.log("CLEAR: " + this.props.image.id)
    this.props.onClear(this.props.image.id)
  }

  handleSubmit (e) {
    e.preventDefault()
    console.log("BEGIN UPLOAD", this.props.image)
    if(!this.props.onUpload) return

    this.props.onUpload(this.props.image)
  }

  render () {
    const {
      image
    } = this.props

    const folders = [
      [ 'default', 'Default' ],
      [ 'scraps', 'Scraps' ],
      [ 'wips', 'WIPs' ]
    ]

    const uploading = image.state === 'uploading'

    return <form onSubmit={this.handleSubmit} className='image-form' style={ { flex: '0 1 300px', display: 'flex', height: 300, flexDirection: 'column' } }>
      <div className='image-data padding--medium padding-bottom--none' style={ { flexGrow: 1, overflow: 'hidden' } }>
        <Row>
          <Input s={ 12 } onChange={ this.handleChange } value={ image.title } type='text' name='title' className='margin-bottom--none' label='Name'/>
        </Row>
        <Row>
          <Input s={ 12 } onChange={ this.handleChange } value={ image.folder } type='select' name='folder' className='margin-bottom--none' label='Folder'>
            { folders.map((i) => <option value={ i[ 0 ] } key={ i[ 0 ] }>{ i[ 1 ] }</option>) }
          </Input>
        </Row>
      </div>

      <div className='image-submit padding--medium padding-top--none' style={ { flexShrink: 0, flexGrow: 0 } }>
        <div className='center margin-bottom--large'>
          <Row>
            <Input s={ 12 } onChange={ this.handleChange } checked={ image.nsfw } type='switch' name='nsfw' offLabel='SFW' onLabel='NSFW' />
          </Row>
        </div>

        <div className={'actions'}>
          <div className='right'>
            <Button type='submit' disabled={uploading}>{ uploading ? 'Uploading...' : 'Upload' }</Button>
          </div>

          { !uploading && <Button type='button' className={'btn low-pad btn-flat'} onClick={this.handleClear.bind(this)}>
            <i className={'material-icons'}>delete</i>
          </Button> }
        </div>
      </div>
    </form>
  }
}

UploadForm.propTypes = {
  image: PropTypes.shape({
    id: PropTypes.number.isRequired,
    name: PropTypes.string.isRequired,
    title: PropTypes.string,
    nsfw: PropTypes.boolean,
    folder: PropTypes.string,
    state: PropTypes.string
  }),
  onChange: PropTypes.func,
  onUpload: PropTypes.func
}

export default UploadForm
