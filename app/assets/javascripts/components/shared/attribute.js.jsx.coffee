@Attribute = (props) ->
  `<li>
      <div className='key'>{ props.name }:</div>
      <div className='value'> { props.value }</div>
  </li>`
