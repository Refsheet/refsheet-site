@CharacterNotice = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  propTypes:
    transfer: React.PropTypes.object


  getInitialState: ->
    transfer: @props?.transfer

  componentWillReceiveProps: (newProps) ->
    @setState transfer: newProps.transfer


  _handleAcceptTransfer: (e) ->
    $.ajax
      url: @state.transfer.path
      data: status: 'claimed'
      type: 'PATCH'
      success: (data) =>
        $(document).trigger 'app:character:reload', data.character_path, (character) =>
          window.history.replaceState {}, '', data.character_path
          Materialize.toast({ html: "Transfer claimed!", displayLength: 3000, classes: 'green' })
      error: (data) =>
        console.error data
        Materialize.toast({ html: "Something went wrong :(", displayLength: 3000, classes: 'red' })
    e.preventDefault()

  _handleRejectTransfer: (e) ->
    $.ajax
      url: @state.transfer.path
      data: status: 'rejected'
      type: 'PATCH'
      success: (data) =>
        @setState transfer: null
        Materialize.toast({ html: "Transfer rejected.", displayLength: 3000, classes: 'green' })
      error: (data) =>
        console.error data
        Materialize.toast({ html: "Something went wrong :(", displayLength: 3000, classes: 'red' })
    e.preventDefault()

  render: ->
    if @state.transfer && @state.transfer?.destination_username == @context.currentUser?.username
      `<div className='character-notice'>
          <div className='notice-text'>
              { this.state.transfer.sender_username } wishes to transfer this character to you.
          </div>

          <div className='notice-action'>
              <a href='#' className='btn-flat margin-right--medium' onClick={ this._handleRejectTransfer }>Reject</a>
              <a href='#' className='btn' onClick={ this._handleAcceptTransfer }>Accept</a>
          </div>
      </div>`

    else
      null
