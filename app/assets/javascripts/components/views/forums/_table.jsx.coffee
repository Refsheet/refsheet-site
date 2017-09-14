@Forums.Table = (props) ->
  { forums, title } = props

  forumCards = forums.map (forum) ->
    `<Column l={6} xl={4} key={ forum.slug }>
        <Forums.Card {...StringUtils.camelizeKeys(forum)} />
    </Column>`

  `<div className='collection-group'>
      <h3 className='group-title margin-top--none'>{ title }</h3>

      <Row>
          { forumCards }
      </Row>
  </div>`
