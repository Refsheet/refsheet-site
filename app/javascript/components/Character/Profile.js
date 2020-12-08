import React, { Component } from 'react'
import PropTypes from 'prop-types'
import ProfileSection from './ProfileSection'
import c from 'classnames'
import { Mutation } from 'react-apollo'
import createProfileSection from './createProfileSection.graphql'
import * as M from 'materialize-css'

class Profile extends Component {
  handleNewSection(lastSection) {
    return e => {
      e.preventDefault()
      this.props
        .createProfileSection({
          variables: {
            characterId: this.props.characterId,
            createAfterSectionId: lastSection,
          },
        })
        .then(({ data, errors }) => {
          if (errors) {
            console.error(errors)
            errors.map(e =>
              M.toast({ html: e.message, classes: 'red', displayLength: 3000 })
            )
          } else {
            console.log({ data })
            this.props.refetch()
          }
        })
        .catch(console.error)
    }
  }

  groupProfileSections() {
    const { profileSections, editable } = this.props
    const groupOrder = []
    const groups = {}

    let lastId = 'main'

    let sorted = [...profileSections]
    sorted.sort((a, b) => (a.row_order || 0) - (b.row_order || 0))

    sorted.map((section, i) => {
      if (section.title || editable) {
        lastId = section.id
      }

      if (!groups[lastId]) {
        groupOrder.push(lastId)
        groups[lastId] = []
      }

      groups[lastId].push({
        ...section,
        first: i === 0,
        last: i >= profileSections.length - 1,
      })
    })

    return [groups, groupOrder]
  }

  renderProfileSections() {
    const { editable, refetch, characterId, character } = this.props
    const [groups, groupOrder] = this.groupProfileSections()
    const render = []

    for (let id of groupOrder) {
      const sections = groups[id]
      let lastSectionId = null

      const renderedSections = sections.map(function (section, i) {
        lastSectionId = section.id

        const classNames = c({
          'margin-bottom--none': sections.length > 0,
          'margin-top--none': i > 0,
        })

        return (
          <ProfileSection
            key={section.id}
            {...section}
            className={classNames}
            editable={editable}
            refetch={refetch}
            characterId={characterId}
            onChange={refetch}
            character={character}
          />
        )
      })

      render.push(
        <div id={'s:' + id} key={id} className="profile-scrollspy">
          {renderedSections}
        </div>
      )

      if (editable) {
        render.push(
          <a
            key={'new-' + id}
            className="btn btn-flat block margin-top--medium margin-bottom--large"
            style={{ border: '1px dashed #ffffff33' }}
            onClick={this.handleNewSection(lastSectionId).bind(this)}
          >
            Add Section
          </a>
        )
      }
    }

    return render
  }

  render() {
    return <div id="profile">{this.renderProfileSections()}</div>
  }
}

Profile.propTypes = {
  profileSections: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.string.isRequired,
      title: PropTypes.string,
    })
  ),
  editable: PropTypes.bool,
  characterId: PropTypes.string.isRequired,
}

const CreateSectionMutation = props => (
  <Mutation mutation={createProfileSection}>
    {createProfileSection => (
      <Profile {...props} createProfileSection={createProfileSection} />
    )}
  </Mutation>
)

export default CreateSectionMutation
