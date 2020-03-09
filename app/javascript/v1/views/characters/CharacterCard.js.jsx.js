/* eslint-disable
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.CharacterCard = React.createClass({
  getInitialState() {
    return {character: this.props.character};
  },

  componentWillUpdate(newProps) {
    if (newProps.character !== this.props.character) {
      return this.setState({character: newProps.character});
    }
  },

  handleAttributeChange(data, onSuccess, onError) {
    const postData =
      {character: {}};
    postData.character[data.id] = data.value;

    return $.ajax({
      url: this.state.character.path,
      type: 'PATCH',
      data: postData,
      success: data => {
        this.setState({character: data});
        return onSuccess();
      },
      error: error => {
        return onError({value: (error.JSONData != null ? error.JSONData.errors[data.id] : undefined)});
      }
    });
  },

  handleSpecialNotesChange(markup, onSuccess, onError) {
    return $.ajax({
      url: this.state.character.path,
      type: 'PATCH',
      data: { character: {special_notes: markup}
    },
      success: data => {
        this.setState({character: data});
        return onSuccess();
      },

      error: error => {
        return onError(error.JSONData != null ? error.JSONData.errors['special_notes'] : undefined);
      }
    });
  },

  handleProfileImageEdit() {
    return $(document).trigger('app:character:profileImage:edit');
  },

  _handleFollow(f) {
    return this.setState(HashUtils.set(this.state, 'character.followed', f), () => Materialize.toast({ html: `Character ${f ? 'followed!' : 'unfollowed.'}`, displayLength: 3000, classes: 'green' }));
  },
      
  _handleChange(char) {
    if (this.props.onChange) { this.props.onChange(char); }
    return this.setState({character: char});
  },

  render() {
    let attributeUpdate, editable, nickname, notesUpdate;
    if (this.props.edit) {
      attributeUpdate = this.handleAttributeChange;
      notesUpdate = this.handleSpecialNotesChange;
      editable = true;
    }

    const description =
      <div className='description'>
          <AttributeTable onAttributeUpdate={ attributeUpdate }
                          defaultValue='Unspecified'
                          freezeName
                          hideEmpty={ !this.props.edit }
                          hideNotesForm>

              <Attribute id='species' name='Species' value={ this.state.character.species } />
          </AttributeTable>
          
          <Views.Character.Attributes characterPath={ this.state.character.path }
                                      attributes={ this.state.character.custom_attributes }
                                      onChange={ this._handleChange }
                                      editable={ editable }
          />

          { (this.state.character.special_notes || editable) &&
              <div className='important-notes margin-top--large margin-bottom--medium'>
                  <h2>Important Notes</h2>
                  <RichText content={ this.state.character.special_notes_html }
                            markup={ this.state.character.special_notes }
                            onChange={ notesUpdate } />
              </div>
          }
      </div>;

    if (this.props.nickname) {
      nickname = <span className='nickname'> ({ this.state.character.nickname })</span>;
    }

    let prefixClass = 'title-prefix';
    const suffixClass = 'title-suffix';

    if (this.props.officialPrefix) {
      prefixClass += ' official';
    }

    if (this.props.officialSuffix) {
      prefixClass += ' official';
    }

    const gravity_crop = {
      center: { objectPosition: 'center' },
      north: { objectPosition: 'top' },
      south: { objectPosition: 'bottom' },
      east: { objectPosition: 'right' },
      west: { objectPosition: 'left' }
    };

    return <div className='character-card' style={{ minHeight: 400 }}>
        <div className='character-details'>
            <div className='heading'>
                <div className='right'>
                    <Views.User.Follow followed={ this.state.character.followed }
                                       username={ this.state.character.user_id }
                                       onFollow={ this._handleFollow }
                                       short />
                </div>

                <h1 className='name'>
                    <span className={ prefixClass }>{ this.props.titlePrefix } </span>
                    <span className='real-name'>{ this.state.character.name }</span>
                    { nickname }
                    <span className={ suffixClass }> { this.props.titleSuffix }</span>
                </h1>
            </div>

            { description }
        </div>

        {/*<div className='user-icon'>
            <Link to={ '/' + this.state.character.user_id } className='tooltipped' data-tooltip={ this.state.character.user_name } data-position='bottom'>
                <img className='circle' src={ this.state.character.user_avatar_url } />
            </Link>
        </div>*/}

        <div className='character-image' onClick={ this.handleImageClick }>
            <div className='slant' />
            <img src={ this.state.character.profile_image.medium }
                 data-image-id={ this.state.character.profile_image.id }
                 style={ gravity_crop[this.state.character.profile_image.gravity] } />

            { editable &&
                <a className='image-edit-overlay' onClick={ this.handleProfileImageEdit }>
                    <div className='content'>
                        <i className='material-icons'>photo_camera</i>
                        Change Image
                    </div>
                </a> }
        </div>
    </div>;
  }
});
