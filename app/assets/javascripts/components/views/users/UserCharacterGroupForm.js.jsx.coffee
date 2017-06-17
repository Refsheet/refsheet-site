#@User.CharacterGroups.Form = React.createClass
@UserCharacterGroupForm = React.createClass
  propTypes:
    group: React.PropTypes.object
    onChange: React.PropTypes.func

  getInitialState: ->
    model:
      name: @props.group?.name || ''

  render: ->
    editing = !!@props.group

    if editing
      method = 'PUT'
      action = @props.group.path
      icon = 'edit'
    else
      method = 'POST'
      action = '/character_groups'
      icon = 'create_new_folder'

    `<li className='form fixed'>
        <Form action={ action }
              model={ this.state.model }
              className='inline'
              modelName='character_group'
              onChange={ this.props.onChange }
              method={ method }>

            <i className='material-icons left folder'>{ icon }</i>

            <Input type='text'
                   placeholder={ editing ? 'Edit Group' : 'New Group' }
                   autoFocus={ editing }
                   name='name' />

            <Submit link noWaves>
                <i className='material-icons'>save</i>
            </Submit>
        </Form>
    </li>`
