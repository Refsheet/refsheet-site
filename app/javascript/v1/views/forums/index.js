/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Forums from 'v1/views/Forums'
import Main from '../../shared/Main'
import Jumbotron from '../../../components/Shared/Jumbotron'
import Container from '../../shared/material/Container'
import EmptyList from '../../shared/EmptyList'
import Loading from '../../shared/Loading'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let Index
export default Index = createReactClass({
  contextTypes: {
    eagerLoad: PropTypes.object,
  },

  propTypes: {
    forums: PropTypes.object,
  },

  dataPath: '/forums',

  getInitialState() {
    return { forums: null }
  },

  UNSAFE_componentWillMount() {
    StateUtils.load(this, 'forums')
  },

  render() {
    let forums
    const forumGroups = HashUtils.groupBy(this.state.forums, 'group_name')
    let forumTables = []

    // Build Table Children
    for (let groupName in forumGroups) {
      forums = forumGroups[groupName]
      forumTables.push(
        <Forums.Table key={groupName} title={groupName} forums={forums} />
      )
    }

    if (!this.state.forums) {
      forumTables = <Loading />
    } else if (forumTables.length === 0) {
      forumTables = <p className="caption center">Nothing to see here :(</p>
    }

    return (
      <Main title="Forums" flex>
        <Jumbotron className="short">
          <h1>Discuss & Socialize</h1>
        </Jumbotron>

        <Container flex>
          <div className="sidebar">
            <EmptyList coffee caption="Recent threads coming soon?" />
          </div>

          <div className="content">{forumTables}</div>
        </Container>
      </Main>
    )
  },
})
