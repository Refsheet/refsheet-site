import validate from './validate'

const FormUtils = {
  handleInputChange: function (modelName) {
    return function (e) {
      let model = { ...this.state[modelName] }
      let value = e.target.value
      let name = e.target.name

      if (e.target.type === 'checkbox') {
        value = e.target.checked
        name = e.target.value
      }

      model[name] = value

      let state = {}
      state[modelName] = model

      if (this.validations) {
        state.errors = validate(model, this.validations)
      }

      this.setState(state)
    }
  },
}

export default FormUtils
