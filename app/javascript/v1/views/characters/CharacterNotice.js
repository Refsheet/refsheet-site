/* eslint-disable
    no-undef,
    no-unused-vars,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.CharacterNotice = React.createClass({
  contextTypes: {
    currentUser: PropTypes.object,
  },

  propTypes: {
    transfer: PropTypes.object,
  },

  getInitialState() {
    return { transfer: this.props != null ? this.props.transfer : undefined }
  },

  componentWillReceiveProps(newProps) {
    return this.setState({ transfer: newProps.transfer })
  },

  _handleAcceptTransfer(e) {
    $.ajax({
      url: this.state.transfer.path,
      data: { status: 'claimed' },
      type: 'PATCH',
      success: data => {
        return $(document).trigger(
          'app:character:reload',
          data.character_path,
          character => {
            window.history.replaceState({}, '', data.character_path)
            return Materialize.toast({
              html: 'Transfer claimed!',
              displayLength: 3000,
              classes: 'green',
            })
          }
        )
      },
      error: data => {
        console.error(data)
        return Materialize.toast({
          html: 'Something went wrong :(',
          displayLength: 3000,
          classes: 'red',
        })
      },
    })
    return e.preventDefault()
  },

  _handleRejectTransfer(e) {
    $.ajax({
      url: this.state.transfer.path,
      data: { status: 'rejected' },
      type: 'PATCH',
      success: data => {
        this.setState({ transfer: null })
        return Materialize.toast({
          html: 'Transfer rejected.',
          displayLength: 3000,
          classes: 'green',
        })
      },
      error: data => {
        console.error(data)
        return Materialize.toast({
          html: 'Something went wrong :(',
          displayLength: 3000,
          classes: 'red',
        })
      },
    })
    return e.preventDefault()
  },

  render() {
    if (
      this.state.transfer &&
      (this.state.transfer != null
        ? this.state.transfer.destination_username
        : undefined) ===
        (this.context.currentUser != null
          ? this.context.currentUser.username
          : undefined)
    ) {
      return (
        <div className="character-notice">
          <div className="notice-text">
            {this.state.transfer.sender_username} wishes to transfer this
            character to you.
          </div>

          <div className="notice-action">
            <a
              href="#"
              className="btn-flat margin-right--medium"
              onClick={this._handleRejectTransfer}
            >
              Reject
            </a>
            <a href="#" className="btn" onClick={this._handleAcceptTransfer}>
              Accept
            </a>
          </div>
        </div>
      )
    } else {
      return null
    }
  },
})
