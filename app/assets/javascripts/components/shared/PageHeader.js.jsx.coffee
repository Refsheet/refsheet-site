@PageHeader = React.createClass
  componentDidMount: ->
    $('.parallax').parallax()

  render: ->
    `<section className='page-header'>
        <div className='parallax-container'>
            <div className='parallax page-header-backdrop'>
                <img src={ this.props.backgroundImage } />
            </div>

            { this.props.onHeaderImageEdit &&
                <a className='btn btn-small btn-icon image-edit-button' onClick={ this.props.onHeaderImageEdit }>
                    <i className='material-icons'>edit</i>
                </a> }
        </div>
        <div className='page-header-content'>
          <div className='container'>
              { this.props.children }
          </div>
        </div>
    </section>`
