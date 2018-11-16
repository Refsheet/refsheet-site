@CharacterDeleteModal = React.createClass
  contextTypes:
    router: React.PropTypes.object.isRequired

  propTypes:
    character: React.PropTypes.object.isRequired


  _handleCharacterDelete: (e) ->
    $.ajax
      url: @props.character.path
      type: 'DELETE'
      success: (data) =>
        $('#delete-form').modal('close')
        Materialize.toast "#{data.name} deleted. :(", 3000
        @context.router.history.push '/' + data.user_id

      error: (error) =>
        Materialize.toast "I'm afraid I couldn't do that, Jim.", 3000, 'red'

    e.preventDefault()

  _handleDeleteClose: (e) ->
    $('#delete-form').modal('close')
    e.preventDefault()

  render: ->
    `<Modal id='delete-form'>
        <h2>Delete Character</h2>
        <p>This action can not be undone! Are you sure?</p>

        <div className='actions margin-top--large'>
            <a className='btn red right' onClick={ this._handleCharacterDelete }>DELETE CHARACTER</a>
            <a className='btn' onClick={ this._handleDeleteClose }>Cancel</a>
        </div>
    </Modal>`
