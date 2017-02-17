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
                <a className='image-edit-overlay for-header' onClick={ this.props.onHeaderImageEdit }>
                    <div className='content'>
                        <i className='material-icons'>photo_camera</i>
                        Change Cover Image
                    </div>
                </a>
            }
        </div>
        <div className='page-header-content'>
          <div className='container'>
              { this.props.children }
          </div>
        </div>
    </section>`
