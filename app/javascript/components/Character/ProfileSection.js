import React, { Component } from 'react'
import PropTypes from 'prop-types'
import ProfileColumn from './ProfileColumn'
import Section from 'Shared/Section'
import c from 'classnames'
import { Mutation } from 'react-apollo'
import { gql } from 'apollo-client-preset'
import NewWidgetModal from './Modals/NewWidgetModal'
import deleteProfileSection from './deleteProfileSection.graphql'
import * as M from 'materialize-css'

class ProfileSection extends Component {
  constructor(props) {
    super(props)

    this.state = {
      newWidget: null,
    }

    this.handleTitleChange = this.handleTitleChange.bind(this)
  }

  handleTitleChange(title) {
    this.props
      .updateSection({
        variables: {
          id: this.props.id,
          title,
        },
      })
      .then(data => {
        console.log(data)
        this.props.refetch()
      })
      .catch(error => console.error(error))
  }

  handleNewWidgetClose() {
    this.setState({ newWidget: null })
  }

  handleNewWidgetClick(column) {
    return e => {
      e.preventDefault()

      this.setState({
        newWidget: {
          sectionId: this.props.id,
          columnId: column,
        },
      })
    }
  }

  handleNewWidget(widget) {
    this.props.onChange()
    this.setState({
      newWidget: null,
    })
  }

  handleDeletedWidget(widgetId) {
    this.props.onChange()
  }

  handleDelete() {
    this.props
      .deleteSection({
        variables: {
          id: this.props.id,
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

  handleMove(direction) {
    this.props
      .updateSection({
        variables: {
          id: this.props.id,
          row_order_position: direction,
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

  renderSectionColumns(columns, widgets, editable) {
    const _this = this
    const { character } = this.props
    return columns.map(function (width, id) {
      const columnWidgets = widgets.filter(w => w.column === id)

      return (
        <ProfileColumn
          key={id}
          id={id}
          width={width}
          widgets={columnWidgets}
          editable={editable}
          last={id >= columns.length - 1}
          character={character}
          onNewClick={_this.handleNewWidgetClick(id).bind(_this)}
          onWidgetDelete={_this.handleDeletedWidget.bind(_this)}
        />
      )
    })
  }

  render() {
    const {
      title,
      columns,
      widgets,
      editable,
      className,
      first,
      last,
    } = this.props

    return (
      <Section
        title={title}
        className={c('margin-bottom--large', className)}
        editable={editable}
        onTitleChange={this.handleTitleChange}
        buttons={[
          {
            icon: 'keyboard_arrow_up',
            hide: !editable || first,
            id: 'up',
            onClick: this.handleMove.bind(this),
          },
          {
            icon: 'keyboard_arrow_down',
            hide: !editable || last,
            id: 'down',
            onClick: this.handleMove.bind(this),
          },
          {
            icon: 'delete',
            title: 'Delete',
            hide: !editable,
            onClick: this.handleDelete.bind(this),
          },
        ]}
      >
        {this.state.newWidget && (
          <NewWidgetModal
            characterId={this.props.characterId}
            sectionId={this.state.newWidget.sectionId}
            columnId={this.state.newWidget.columnId}
            onClose={this.handleNewWidgetClose.bind(this)}
            onCreate={this.handleNewWidget.bind(this)}
          />
        )}

        <div className="row margin-top--medium">
          {this.renderSectionColumns(columns, widgets, editable)}
        </div>
      </Section>
    )
  }
}

ProfileSection.propTypes = {
  columns: PropTypes.array.isRequired,
  id: PropTypes.string.isRequired,
  characterId: PropTypes.string.isRequired,
  title: PropTypes.string,
  onChange: PropTypes.func,
  editable: PropTypes.bool,
  className: PropTypes.string,
  deleteSection: PropTypes.func,
  first: PropTypes.bool,
  last: PropTypes.bool,
}

const UPDATE_SECTION_MUTATION = gql`
  mutation updateProfileSection(
    $id: ID!
    $title: String
    $row_order_position: String
  ) {
    updateProfileSection(
      id: $id
      title: $title
      row_order_position: $row_order_position
    ) {
      title
    }
  }
`

const Wrapped = props => (
  <Mutation mutation={UPDATE_SECTION_MUTATION}>
    {(updateSection, { mutationData }) => (
      <Mutation mutation={deleteProfileSection}>
        {deleteSection => (
          <ProfileSection
            {...props}
            deleteSection={deleteSection}
            updateSection={updateSection}
            mutationData={mutationData}
          />
        )}
      </Mutation>
    )}
  </Mutation>
)

export default Wrapped
