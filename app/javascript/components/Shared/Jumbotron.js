import React from 'react'
import c from 'classnames'

const Jumbotron = (props) => (
  <div className={ c('jumbotron', props.classname, {short: props.short}) }>
    <div className='jumbotron-background'>
      <div className='container'>{ props.children }</div>
    </div>
  </div>
)

export default Jumbotron