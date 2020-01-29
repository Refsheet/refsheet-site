import React from 'react'

// Helper for re-importing V1 code
function v1(componentName) {
  return props => {
    const component = window[componentName]
    console.warn(
      `Use of "${componentName}" from V1 javascript package ` +
        'is deprecated. Please migrate this component to V2 or stop using it. ' +
        '(See Shared/V1.js for details and re-exports.)'
    )

    return React.createElement(component, props)
  }
}

// Define V1 imports here, turning them into factories which can be resolved
// at runtime. There is a helper for this which will print a deprecation warning.
// See existing examples for details.

const Modal = v1('Modal')

export { Modal }
