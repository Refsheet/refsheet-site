/* do-not-disable-eslint
    react/display-name,
    react/jsx-no-undef,
    react/prop-types,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Main from '../../../components/Shared/Main'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const CharacterViewSilhouette = props => (
  <Main title={props.title || 'Loading...'} className="silhouette">
    <section className="page-header">
      <div
        className="page-header-backdrop silhouette-backdrop"
        style={{ backgroundImage: 'url(' + props.coverImage + ')' }}
      />

      <div className="page-header-content">
        <div className="container">
          <div className="character-card">
            <div className="character-details">
              <h1 className="name silhouette-text" />
              <div className="silhouette-stagger">
                <div className="silhouette-text margin-top--large" />
                <div className="silhouette-text margin-top--medium" />
                <div className="silhouette-text margin-top--medium" />
                <div className="silhouette-text margin-top--medium" />
              </div>

              <h2 className="silhouette-text margin-top--large" />
              <div className="silhouette-stagger">
                <div className="silhouette-text" />
              </div>
            </div>

            <div className="character-image silhouette-image">
              <div className="slant" />
            </div>
          </div>

          <div className="card-panel" />
        </div>
      </div>
    </section>

    <section>
      <div className="container">
        <div className="card-panel">
          <h1 className="silhouette-text" />
          <div className="silhouette-stagger">
            <div className="silhouette-text margin-top--large" />
            <div className="silhouette-text margin-top--medium" />
            <div className="silhouette-text margin-top--medium" />
            <div className="silhouette-text margin-top--medium" />
          </div>
        </div>
      </div>
    </section>
  </Main>
)

export default CharacterViewSilhouette
