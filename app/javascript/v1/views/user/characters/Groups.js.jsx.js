/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.User.Characters.Groups = React.createClass({
  propTypes: {
    userLink: React.PropTypes.string.isRequired,
    groups: React.PropTypes.array.isRequired,
    editable: React.PropTypes.bool,
    totalCount: React.PropTypes.number,
    onChange: React.PropTypes.func.isRequired,
    onSort: React.PropTypes.func.isRequired,
    onGroupDelete: React.PropTypes.func.isRequired,
    onCharacterDelete: React.PropTypes.func.isRequired,
    activeGroupId: React.PropTypes.string
  },

  getInitialState() {
    return {dragging: false};
  },

  componentDidMount() {
    return this._initialize();
  },

  componentDidUpdate() {
    return this._initialize();
  },


  _initialize() {
    const $list = $(this.refs.list);

    return $list.sortable({
      items: 'li.sortable-link',
      placeholder: 'drop-target',
      forcePlaceholderSize: true,
      start: () => {
        return this.setState({dragging: true});
      },

      stop: (_, el) => {
        return this.setState({dragging: false});
      },

      update: (_, el) => {
        this.setState({dragging: false});
        if ($(el.item[0]).hasClass('dropped')) {
          $(el.item[0]).removeClass('dropped');
          return $list.sortable('cancel');

        } else {
          const $item = $(el.item[0]);
          const position = $item.parent().children('.sortable-link').index($item);
          return this._handleSwap($item.data('group-id'), position);
        }
      }
    });
  },

  _handleSwap(id, position) {
    const group = (this.props.groups.filter(g => g.slug === id))[0];

    return Model.put(group.path, {character_group: {row_order_position: position}}, data => {
      return this.props.onSort(data, position);
    });
  },


  render() {
    let groups;
    const { onChange, editable } = this.props;
    const dragging = false;

    if (this.props.groups.length) {
      const _this = this;

      groups = this.props.groups.map(group => <UserCharacterGroupLink group={ group }
                               editable={ editable }
                               onChange={ onChange }
                               active={ _this.props.activeGroupId == group.slug }
                               key={ group.slug } />);
    }

    return <div>
        <ul className='character-group-list margin-bottom--none' ref='list'>
            <li className={ 'all fixed' + (!window.location.hash ? ' active' : '') }>
                <i className='material-icons left folder'>person</i>
                <Link to={ this.props.userLink } className='name'>All Characters</Link>
                <span className='count'>{ NumberUtils.format(this.props.totalCount) }</span>
            </li>

            { groups }

        </ul>

        { editable &&
            <ul className='character-group-list'>
                { this.state.dragging
                    ? <UserCharacterGroupTrash onChange={ this.props.onChange }
                                               onCharacterDelete={ this.props.onCharacterDelete }
                                               onGroupDelete={ this.props.onGroupDelete }
                                               activeGroupId={ this.props.activeGroupId } />
                    : <UserCharacterGroupForm onChange={ this.props.onChange } />
                }

                { dragging &&
                    <UserCharacterGroupTrash /> }
            </ul>
        }

        { editable &&
            <div className='hint'>
                <div className='strong'>Hint:</div>
                <div className='text'>Drag groups and characters (on All Characters page) to rearrange. Drag characters to a group to add/remove.</div>
            </div> }
    </div>;
  }
});
