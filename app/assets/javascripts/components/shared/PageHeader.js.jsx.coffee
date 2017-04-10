@PageHeader = React.createClass
  render: ->
    `<section className='page-header'>
        <div className='page-header-backdrop' style={{backgroundImage: "url(" + this.props.backgroundImage + ")"}}>
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
