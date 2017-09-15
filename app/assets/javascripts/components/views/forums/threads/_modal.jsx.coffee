@Forums.Threads.Modal = React.createClass
  contextTypes:
    router: React.PropTypes.object.isRequired

  propTypes:
    forumId: React.PropTypes.string.isRequired

  getInitialState: ->
    thread:
      topic: null
      content: null


  _handleCreate: (thread) ->
    Materialize.toast "Thread created! Hope it's a good one :)", 3000, 'green'
    @refs.modal.close()
    console.log thread
    @context.router.push thread.path

  render: ->
    `<Modal id='new-thread-modal' title='New Thread' ref='modal'>
        <Form action={ '/forums/' + this.props.forumId + '/threads' }
              method='POST'
              model={ this.state.thread }
              modelName='thread'
              onChange={ this._handleCreate }
        >
            <Input name='topic' label='Topic' />
            <Input name='content' label='Content' type='textarea' />

            <Row className='actions right-align' oneColumn>
                <Submit>Start Thread</Submit>
            </Row>
        </Form>
    </Modal>`
