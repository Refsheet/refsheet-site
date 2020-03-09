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
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.User.Characters = React.createClass({
  propTypes: {
    groups: React.PropTypes.array.isRequired,
    characters: React.PropTypes.array.isRequired,
    editable: React.PropTypes.bool,
    userLink: React.PropTypes.string,
    activeGroupId: React.PropTypes.string,
    onGroupChange: React.PropTypes.func.isRequired,
    onGroupSort: React.PropTypes.func.isRequired,
    onGroupDelete: React.PropTypes.func.isRequired,
    onCharacterDelete: React.PropTypes.func.isRequired,
    onCharacterSort: React.PropTypes.func.isRequired
},


  render() {
    let listEditable;
    const { groups, characters, editable, userLink, activeGroupId, onGroupChange, onGroupSort, onGroupDelete, onCharacterDelete, onCharacterSort } = this.props;

    if (activeGroupId) {
      listEditable = false;
    } else {
      listEditable = editable;
  }

    return <div className='sidebar-container'>
        <div className='sidebar'>
            { editable &&
                <a href='#character-form' className='margin-bottom--large btn btn-block center waves-effect waves-light modal-trigger'>
                    New Character
                </a>
            }

            <User.Characters.Groups groups={ groups }
                                    editable={ editable }
                                    totalCount={ characters.length }
                                    onChange={ onGroupChange }
                                    onSort={ onGroupSort }
                                    onGroupDelete={ onGroupDelete }
                                    onCharacterDelete={ onCharacterDelete }
                                    activeGroupId={ activeGroupId }
                                    userLink={ userLink }
            />
        </div>

        <div className='main-content'>
            <User.Characters.List characters={ characters }
                                  activeGroupId={ activeGroupId }
                                  onSort={ onCharacterSort }
                                  editable={ listEditable }
            />
        </div>
    </div>;
}
});
