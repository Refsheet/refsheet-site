@CharacterDetailView = React.createClass
  componentDidMount: ->
    $('.image-gallery .image').draggable
      revert: true

    $('.image-gallery .image').droppable
      drop: (event, ui) ->
        $sP = ui.draggable.parent()
        $tP = $(this).parent()

        $tP.append ui.draggable
        $sP.append $(this)

        ui.draggable.css
          left: ''
          top: ''

  render: ->
    `<div>
        <PageHeader backgroundImage="/assets/unsplash/sand.jpg">
            <CharacterCard detailView={ true } character={ this.props.character } />
        </PageHeader>

        <SwatchPanel swatchesPath={ this.props.character.path + '/swatches/' } swatches={ this.props.character.swatches } />

        <section className='image-gallery'>
            <div className='container'>
                <div className='row'>
                    <div className='col m8 s12'>
                        <div className='image'>
                            <img src='/assets/unsplash/fox.jpg' />
                        </div>
                    </div>
                    <div className='col m4 s12'>
                        <div className='row'>
                            <div className='col m12 s6'>
                                <div className='image'>
                                    <img src='/assets/unsplash/sand.jpg' />
                                </div>
                            </div>
                            <div className='col m12 s6'>
                                <div className='image'>
                                    <img src='http://placehold.it/519x321' />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <Link to={ this.props.character.path }
              className='side-nav-trigger tooltipped'
              data-tooltip='Character Profile'
              data-position='right'>

            <i className='material-icons'>perm_identity</i>
        </Link>
    </div>`
