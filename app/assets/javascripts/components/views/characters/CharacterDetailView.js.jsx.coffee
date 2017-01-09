@CharacterDetailView = React.createClass
  render: ->
    `<div>
        <PageHeader backgroundImage={ this.props.character.featured_image.url }>
            <CharacterCard detailView={ true } character={ this.props.character } />
            <SwatchPanel edit={ true } swatchesPath={ this.props.character.path + '/swatches/' } swatches={ this.props.character.swatches } />
        </PageHeader>

        <ImageGallery edit={ true } imagesPath={ this.props.character.path + '/images/' } onImageClick={ this.props.onLightbox } />
    </div>`
