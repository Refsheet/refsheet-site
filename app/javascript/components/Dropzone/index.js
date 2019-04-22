import React, { Component } from 'react'
import PropTypes from 'prop-types'
import ReactDropzone from 'react-dropzone'
import {connect} from "react-redux";
import {enqueueUploads} from "../../actions";

class Dropzone extends Component {
  constructor(props) {
    super(props);

    this.state = {
      dropzoneActive: false
    }

    this.dropzone = null
    this.counter = 0
  }

  getChildContext() {
    return {
      getDropzone: () => this.dropzone
    }
  }

  onDrop(acceptedFiles, rejectedFiles) {
    let pending = []

    acceptedFiles.forEach((file) => {
      const filename = file.name
        .replace(/\..*?$/, '')
        .replace(/[-_]+/g, ' ')
        .replace(/\s+/, ' ')

      const image = {
        id: this.counter++,
        title: filename,
        folder: 'default',
        nsfw: false,
        state: 'pending',
        progress: 0
      }

      Object.assign(file, image)
      pending.push(file)
    })

    this.props.enqueueUploads(pending)
    this.setState({dropzoneActive: false})

    rejectedFiles.forEach((file) => {
      console.warn("File invalid:", file)

      if (file.getAsString) {
        file.getAsString((str) => {
          console.warn("Did you mean to upload:", str)
        })
      }

      if (file.name) {
        Materialize.toast(file.name + ' is invalid.', 3000, 'red')
      }
    })
  }

  onDragEnter() {
    this.setState({
      dropzoneActive: true
    })
  }

  onDragLeave() {
    this.setState({
      dropzoneActive: false
    })
  }

  render() {
    if(!this.props.currentUser) {
      return this.props.children
    } else {
      const {
        dropzoneActive
      } = this.state

      const overlayStyle = {
        position: 'fixed',
        top: 0,
        right: 0,
        bottom: 0,
        left: 0,
        padding: '2.5rem 0',
        background: 'rgba(0,0,0,0.5)',
        textAlign: 'center',
        color: '#fff',
        zIndex: '9999',
        verticalAlign: 'middle',
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'center'
      }

      const iconStyle = {
        fontSize: '3rem'
      }

      return (
        <ReactDropzone
          ref={r => this.dropzone = r}
          disableClick
          style={{}}
          onDrop={this.onDrop.bind(this)}
          onDragEnter={this.onDragEnter.bind(this)}
          onDragLeave={this.onDragLeave.bind(this)}
        >
          { dropzoneActive && <div style={overlayStyle}>
            <i className={'material-icons'} style={iconStyle}>cloud_upload</i>
            <h1>Drop files...</h1>
          </div> }
          { this.props.children }
        </ReactDropzone>
      )
    }
  }
}

Dropzone.childContextTypes = {
  getDropzone: PropTypes.func
}

const mapStateToProps = ({session}) => {
  return {
    currentUser: session.currentUser
  }
}

const mapDispatchToProps = {
  enqueueUploads
}

export default connect(mapStateToProps, mapDispatchToProps)(Dropzone)