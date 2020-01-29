import React from 'react'
import { Mutation } from 'react-apollo'
import { connect } from 'react-redux'
import M from 'materialize-css'

function compose() {
  return component => {
    let func = component

    Array.from(arguments)
      .reverse()
      .map(arg => {
        func = arg(func)
      })

    return func
  }
}

function withMutations(mutations) {
  const mutationNames = Object.keys(mutations)

  const wrap = fn => {
    return attrs => {
      if (attrs && attrs.wrapped) {
        delete attrs.wrapped

        return new Promise((resolve, reject) => {
          fn(attrs)
            .then(data => {
              if (data.errors && data.errors.length > 0) {
                data.validationErrors = {}
                data.errorStrings = []
                data.errors.map(err => {
                  data.errorStrings.push(err.msg)
                  if (err.extensions && err.extensions.validation) {
                    Object.keys(err.extensions.validation).map(k => {
                      if (!data.validationErrors[k])
                        data.validationErrors[k] = []
                      data.validationErrors[k] = [
                        ...data.validationErrors[k],
                        ...err.extensions.validation[k],
                      ]
                    })
                  }
                })

                // Join errors and flatten
                data.formErrors = {}
                Object.keys(data.validationErrors).map(k => {
                  data.formErrors[k] = data.validationErrors[k].join(', ')
                })

                data.errorString = data.errorStrings.join(', ')

                console.error(
                  'GraphQL returned an error: ',
                  data.errors,
                  data.validationErrors
                )
                data.errors.map(e =>
                  M.toast({
                    html: e.message,
                    classes: 'red',
                    displayLength: 3000,
                  })
                )
                reject(data)
              }

              resolve(data)
            })
            .catch(e => {
              console.error(e)
              reject(e)
            })
        })
      }

      return fn(attrs)
    }
  }

  return Component => props => {
    let Result = props => <Component {...props} />

    mutationNames.map(mutationName => {
      const mutation = mutations[mutationName]
      const PreviousResult = Result

      Result = props => (
        <Mutation mutation={mutation}>
          {func => {
            let newProps = { ...props }
            newProps[mutationName] = wrap(func)
            return <PreviousResult {...newProps} />
          }}
        </Mutation>
      )
    })

    return <Result {...props} />
  }
}

function withCurrentUser() {
  const mapStateToProps = (state, props) => ({
    currentUser: state.session.currentUser,
    ...props,
  })

  return connect(mapStateToProps)
}

export { withMutations, withCurrentUser }

export default compose
