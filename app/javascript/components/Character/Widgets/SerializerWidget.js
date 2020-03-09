SerializerWidget = (props) ->
  `<div className='card-content'>
    <code>{ JSON.stringify(props) }</code>
  </div>`

export default SerializerWidget
