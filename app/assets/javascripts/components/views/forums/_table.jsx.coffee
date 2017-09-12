@Forums.Table = (props) ->
  { forums, title } = props

  forumCards = forums.map (forum) ->
    `<Column m={4}>
        <Forums.Card {...HashUtils.camelizeKeys(forum)} />
    </Column>`

  `<div className='collection-group'>
      <h2 className='group-title'>{ title }</h2>

      <Row>
          { forumCards }
      </Row>
  </div>`
