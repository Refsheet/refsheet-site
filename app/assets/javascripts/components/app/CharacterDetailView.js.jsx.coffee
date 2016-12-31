@CharacterDetailView = React.createClass
  render: ->
    `<div>
        <PageHeader backgroundImage="/assets/unsplash/sand.jpg">
            <CharacterCard detailView={ true } character={ this.props.character } />
        </PageHeader>

        <SwatchPanel swatchesPath={ this.props.character.path + '/swatches/' } swatches={ this.props.character.swatches } />

        <ImageGallery />

        <Link to={ this.props.character.path }
              className='side-nav-trigger tooltipped'
              data-tooltip='Character Profile'
              data-position='right'>

            <i className='material-icons'>perm_identity</i>
        </Link>
    </div>`
