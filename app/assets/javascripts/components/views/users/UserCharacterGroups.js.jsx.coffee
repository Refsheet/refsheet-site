@UserCharacterGroups = React.createClass
  propTypes:
    groups: React.PropTypes.array.isRequired

  getInitialState: ->
    model:
      name: null
      hidden: null
      slug: null

  render: ->
    if @props.groups.length
      groups = @props.groups.map (group) ->
        `<li key={ group.slug }>
            <Link to={ group.link }>{ group.name }</Link>
        </li>`

    `<ul className='link-list'>
        { groups }

        <li>
            <Form action='/character_groups.json'
                  model={ this.state.model }
                  modelName='character_group'
                  method='POST'>

                <Input type='text'
                       label='New Group Name'
                       name='name' />

                <Submit />
            </Form>
        </li>
    </ul>`
