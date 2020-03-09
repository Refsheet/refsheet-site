/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.Views.Account.Activities.Character = React.createClass({
  propTypes: {
    characters: React.PropTypes.array.isRequired,
    username: React.PropTypes.string.isRequired
},

  render() {
    const characters = this.props.characters.map(character => {
      const identity = {
        username: this.props.username,
        name: character.name,
        avatarUrl: character.profile_image_url,
        link: character.link,
        type: 'character'
    };

      return <Row key={ character.id } oneColumn noMargin>
          <div className='character-card compact-mobile z-depth-0 margin-bottom--none margin-top--small' style={{ backgroundColor: '#1a1a1a', overflow: 'visible' }}>
              <div className='character-details' style={{ minHeight: 'initial' }}>
                  <h3 className='name margin-top--none'>
                      <IdentityLink to={ identity } />
                  </h3>

                  <div className='description'>
                      <AttributeTable defaultValue='Unspecified'>
                          <Attribute id='species' name='Species' value={ character.species } />
                          <Attribute id='gender' name='gender' value={ character.gender } />
                      </AttributeTable>
                  </div>
              </div>

              <div className='character-image' onClick={ this.handleImageClick }>
                  <div className='slant' style={{ backgroundColor: '#1a1a1a' }} />
                  <img src={ character.profile_image_url } />
              </div>
          </div>
      </Row>;
    });

    return <div className='activity shift-up'>
        { characters }
    </div>;
}
});
