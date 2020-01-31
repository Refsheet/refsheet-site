import request from 'superagent'
import client from 'ApplicationService'
import xmljs from 'xml-js'
// TODO: Make this a mutation too, it deserves it.
import getImageUploadToken from 'graphql/queries/getImageUploadToken.graphql'
import uploadImage from 'graphql/mutations/uploadImage.graphql'

class ImageHandler {
  static upload(image, characterId, onChange) {
    const handler = new this(image, characterId, onChange)
    return handler.upload()
  }

  constructor(image, characterId, onChange) {
    this.image = image
    this.characterId = characterId
    this.onChange = onChange

    this.error = this.error.bind(this)
  }

  upload() {
    console.debug('ImageHandler#upload', this.image, this.characterId)

    return this.getS3Token()
      .then(response => {
        return this.postToS3(response)
      })
      .then(response => {
        return this.updateImageRecord(response)
      })
      .then(response => {
        return this.finalize(response)
      })
      .catch(this.error)
  }

  getS3Token() {
    const variables = { characterId: this.characterId }
    return client.query({ query: getImageUploadToken, variables })
  }

  postToS3(response) {
    if (response.errors) {
      return Promise.reject(response.errors)
    }

    const token = response.data && response.data.getImageUploadToken

    if (!token) {
      return Promise.reject({
        error:
          'An upload token could not be generated. Is a character selected?',
      })
    }

    const { url, __typename, ...awsHeaders } = token

    console.debug(`Posting file to ${url}`)

    const formData = new FormData()

    Object.keys(awsHeaders).forEach(key => {
      formData.append(key.replace(/^x_amz_/, 'x-amz-'), awsHeaders[key])
    })

    formData.append('Content-Type', this.image.type)
    formData.append('file', this.image)

    return request
      .post(url)
      .send(formData)
      .on('progress', e => {
        this.image.progress = Math.ceil(e.percent)
        this.onChange(this.image)
      })
      .then(response => {
        const data = xmljs.xml2js(response.text, { compact: true })
        const obj = data && data.PostResponse

        return (
          obj && {
            bucket: obj.Bucket._text,
            etag: obj.ETag._text,
            key: obj.Key._text,
            location: obj.Location._text,
          }
        )
      })
  }

  updateImageRecord(response) {
    const { title, folder, nsfw } = this.image

    const variables = {
      ...response,
      title,
      folder,
      nsfw,
      characterId: this.characterId,
    }

    console.debug('Telling Refsheet all about this!', variables)

    return client.mutate({ mutation: uploadImage, variables })
  }

  finalize(response) {
    if (response.errors) {
      return Promise.reject(response.errors)
    }

    const image = response.data && response.data.uploadImage

    const { id, ...imageData } = image

    const final = {
      ...this.image,
      ...imageData,
      guid: id,
      state: 'done',
      progress: 100,
    }

    console.debug('UPLOAD DONE', image, final)
    this.onChange(final)
    return final
  }

  // PRIVATE

  error(error) {
    const errorMessage = ImageHandler.findError(error)
    const image = Object.assign({}, this.image)
    console.error(error, errorMessage)

    image.progress = 100
    image.state = 'error'
    image.errorMessage = errorMessage

    this.onChange(image)

    return Promise.reject(error)
  }

  static findError(error) {
    if (error.map) {
      return error.map(e => e.message).join(', ')
    }

    return (
      (error.response &&
        error.response.body &&
        (error.response.body.error || error.response.body)) ||
      error.error ||
      'Something went wrong.'
    )
  }
}

export default ImageHandler
