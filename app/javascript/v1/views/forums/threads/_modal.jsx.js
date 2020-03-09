/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.Forums.Threads.Modal = React.createClass({
  contextTypes: {
    router: React.PropTypes.object.isRequired
  },

  propTypes: {
    forumId: React.PropTypes.string.isRequired
  },

  getInitialState() {
    return {
      thread: {
        topic: null,
        content: null
      }
    };
  },


  _handleCreate(thread) {
    Materialize.toast({ html: "Thread created! Hope it's a good one :)", displayLength: 3000, classes: 'green' });
    this.refs.modal.close();
    console.log(thread);
    return this.context.router.history.push(thread.path);
  },

  render() {
    return <Modal id='new-thread-modal' title='New Thread' ref='modal'>
        <Form action={ '/forums/' + this.props.forumId + '/threads' }
              method='POST'
              model={ this.state.thread }
              modelName='thread'
              onChange={ this._handleCreate }
              className='reply-box not-really-tho'
        >
            <Input name='topic' label='Topic' />
            <Input name='content' placeholder='What would you like to say?' type='textarea' browserDefault />

            <Row className='actions right-align' oneColumn>
                <Submit>Start Thread</Submit>
            </Row>
        </Form>
    </Modal>;
  }
});
