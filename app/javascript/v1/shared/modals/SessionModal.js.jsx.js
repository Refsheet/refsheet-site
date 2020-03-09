/* eslint-disable
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/no-string-refs,
    react/react-in-jsx-scope,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.SessionModal = React.createClass({
  getInitialState() {
    return {view: 'login'};
  },

  close() {
    return M.Modal.getInstance(document.getElementById('session-modal')).close();
  },

  view(view) {
    return $(this.refs.view).fadeOut(300, () => {
      return this.setState({view}, () => {
        return $(this.refs.view).fadeIn(300);
      });
    });
  },

  _handleHelpClick(e) {
    this.view('help');
    return e.preventDefault();
  },

  _handleComplete() {
    return this.view('login');
  },

  render() {
    const view = (() => { switch (this.state.view) {
      case 'help':
        return <PasswordResetForm onComplete={ this.close } onSignInClick={ this._handleComplete } />;

      default:
        return <LoginForm onLogin={ this.close }>
            <div className='right-align'>
                <a href='/login' onClick={ this._handleHelpClick }>Forgot password?</a>
            </div>
        </LoginForm>;
    } })();

    return <Modal id='session-modal'
            title='Welcome back!'
            onClose={ this._handleComplete }
            className='narrow'>
        <div ref='view' className='flex'>
            { view }
        </div>
    </Modal>;
  }
});
