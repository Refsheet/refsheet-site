@Views.Account.Activities.StatusUpdate = React.createClass
  propTypes:
    comment: React.PropTypes.string.isRequired

  render: ->
    lines = this.props.comment.split('\n')

    `<div className='activity'>
      <div className='headline padding-bottom--medium'>
        { lines.map((line, i) => (
          <span key={i}>{line}<br/></span>
        )) }
      </div>
    </div>`
