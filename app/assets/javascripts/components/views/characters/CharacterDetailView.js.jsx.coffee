@CharacterDetailView = React.createClass
  render: ->
    `<div>
        <PageHeader backgroundImage="/assets/unsplash/sand.jpg">
            <CharacterCard detailView={ true } character={ this.props.character } />
        </PageHeader>

        <SwatchPanel edit={ true } swatchesPath={ this.props.character.path + '/swatches/' } swatches={ this.props.character.swatches } />

        <ImageGallery edit={ true } imagesPath={ this.props.character.path + '/images/' } onImageClick={ this.props.onLightbox } />

        <Link to={ this.props.character.path }
              className='side-nav-trigger tooltipped'
              data-tooltip='Character Profile'
              data-position='right'>

            <i className='material-icons'>perm_identity</i>
        </Link>
    </div>`
