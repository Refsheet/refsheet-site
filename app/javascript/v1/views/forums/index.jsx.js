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
this.Forums.Index = React.createClass({
  contextTypes: {
    eagerLoad: React.PropTypes.object
  },

  propTypes: {
    forums: React.PropTypes.object
  },

  dataPath: '/forums',

  getInitialState() {
    return {forums: null};
  },

  componentWillMount() {
    return StateUtils.load(this, 'forums');
  },

  render() {
    let forums;
    const forumGroups = HashUtils.groupBy(this.state.forums, 'group_name');
    let forumTables = [];

    // Build Table Children
    for (let groupName in forumGroups) {
      forums = forumGroups[groupName];
      forumTables.push(
        <Forums.Table key={ groupName } title={ groupName } forums={ forums } />
      );
    }

    if (!this.state.forums) {
      forumTables =
        <Loading />;

    } else if (forumTables.length === 0) {
      forumTables =
        <p className='caption center'>Nothing to see here :(</p>;
    }

    return <Main title='Forums' flex>
        <Jumbotron className='short'>
            <h1>Discuss & Socialize</h1>
        </Jumbotron>

        <Container flex>
            <div className='sidebar'>
                <EmptyList coffee caption='Recent threads coming soon?' />
            </div>

            <div className='content'>
                { forumTables }
            </div>
        </Container>
    </Main>;
  }
});
