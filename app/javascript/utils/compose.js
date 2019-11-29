import React from "react";
import {Mutation} from "react-apollo";

function compose() {
  return (component) => {
    let func = component

    Array.from(arguments).reverse().map(arg => {
      console.log({arg, func})
      func = arg(func)
    })

    return func
  }
}

function withMutations(mutations) {
  const mutationNames = Object.keys(mutations)

  return (Component) => (props) => {
    let Result = (props) => <Component {...props} />

    mutationNames.map(mutationName => {
      const mutation = mutations[mutationName]
      const PreviousResult = Result

      Result = (props) => (
        <Mutation mutation={mutation}>
          { (func) => {
            let newProps = {...props}
            newProps[mutationName] = func
            return <PreviousResult {...newProps} />
          } }
        </Mutation>
      )
    })

    return <Result {...props} />
  }
}

export {
  withMutations
}

export default compose