@PageHeader = React.createClass
  componentDidMount: ->
    $('.parallax').parallax()

  render: ->
    `<section className='page-header'>
        <div className='parallax-container'>
            <div className='parallax page-header-backdrop'>
                <img src={ this.props.backgroundImage } />
            </div>
        </div>
        <div className='page-header-content'>
          <div className='container'>
              { this.props.children }
          </div>
        </div>
    </section>`
