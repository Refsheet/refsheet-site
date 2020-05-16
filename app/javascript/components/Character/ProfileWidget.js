import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { camelize } from 'utils/ObjectUtils'
import widgets, { SerializerWidget } from './Widgets'
import ProfileWidgetHeader from './ProfileWidgetHeader'
import { Mutation } from 'react-apollo'
import updateProfileWidget from './updateProfileWidget.graphql'
import deleteProfileWidget from './deleteProfileWidget.graphql'
import * as M from 'materialize-css'
import { div as Card } from '../Styled/Card'
import compose from '../../utils/compose'
import { withErrorBoundary } from '../Shared/ErrorBoundary'

class ProfileWidget extends Component {
  constructor(props) {
    super(props)

    this.state = {
      editing: false,
      saving: false,
      widgetData: props.data,
    }
  }

  handleEditStart() {
    this.setState({ editing: true })
  }

  handleEditStop(save = true) {
    let state = { editing: false, saving: false }

    if (!save) {
      state.widgetData = this.props.data
    }

    this.setState(state)
  }

  handleDelete() {
    const payload = {
      id: this.props.id,
    }

    this.props
      .deleteWidget({ variables: payload })
      .then(({ data, errors }) => {
        if (errors) {
          console.error(errors)
          errors.map(e =>
            M.toast({ html: e.message, classes: 'red', displayLength: 3000 })
          )
        } else {
          const { deleteProfileWidget: widgetData } = data
          this.props.onDelete && this.props.onDelete(widgetData.id)
        }
      })
      .catch(error => console.error(error))
  }

  handleMove(direction) {
    const payload = {
      id: this.props.id,
    }

    if (direction === 'up' || direction === 'down') {
      payload['row_order_position'] = direction
    } else if (direction === 'left') {
      payload['column'] = this.props.column - 1
    } else if (direction === 'right') {
      payload['column'] = this.props.column + 1
    }

    this.props
      .update({ variables: payload })
      .then(({ data, errors }) => {
        if (errors) {
          console.error(errors)
          errors.map(e =>
            M.toast({ html: e.message, classes: 'red', displayLength: 3000 })
          )
        } else {
          const { updateProfileWidget: widgetData } = data
          this.props.onChange && this.props.onChange(widgetData)
        }
      })
      .catch(error => console.error(error))
  }

  handleSave(title) {
    const payload = {
      id: this.props.id,
      data: JSON.stringify(this.state.widgetData),
      title: title,
    }

    this.setState({ saving: true })

    this.props
      .update({ variables: payload })
      .then(({ data, errors }) => {
        if (errors) {
          console.error(errors)
          errors.map(e =>
            M.toast({ html: e.message, classes: 'red', displayLength: 3000 })
          )
        } else {
          const { updateProfileWidget: widgetData } = data

          this.setState({ saving: false, widgetData: widgetData.data })
          this.props.onChange && this.props.onChange(widgetData)
          this.handleEditStop()
        }
      })
      .catch(error => console.error(error))
  }

  handleWidgetChange(widgetData) {
    this.setState({
      widgetData: {
        ...this.state.widgetData,
        ...widgetData,
      },
    })
  }

  render() {
    const {
      widgetType,
      title,
      editable,
      lastColumn,
      firstColumn,
      first,
      last,
      character,
    } = this.props
    const Widget = widgets[widgetType] || SerializerWidget

    return (
      <Card className="card profile-widget margin-top--none margin-bottom--large margin-bottom-last--none">
        <ProfileWidgetHeader
          widgetType={widgetType}
          title={title}
          editable={editable}
          editing={this.state.editing}
          onEditStart={this.handleEditStart.bind(this)}
          onEditStop={this.handleEditStop.bind(this)}
          onSave={this.handleSave.bind(this)}
          onMove={this.handleMove.bind(this)}
          onDelete={this.handleDelete.bind(this)}
          saving={this.state.saving}
          lastColumn={lastColumn}
          firstColumn={firstColumn}
          first={first}
          last={last}
        />

        <Widget
          {...camelize(this.state.widgetData)}
          character={character}
          onChange={this.handleWidgetChange.bind(this)}
          editing={this.state.editing}
          saving={this.state.saving}
        />
      </Card>
    )
  }
}

ProfileWidget.propTypes = {
  id: PropTypes.string.isRequired,
  widgetType: PropTypes.string.isRequired,
  data: PropTypes.object.isRequired,
  onChange: PropTypes.func,
  editable: PropTypes.bool,
  update: PropTypes.func.isRequired,
  deleteWidget: PropTypes.func.isRequired,
  lastColumn: PropTypes.bool,
  firstColumn: PropTypes.bool,
  first: PropTypes.bool,
  last: PropTypes.bool,
}

const Mutated = props => (
  <Mutation mutation={updateProfileWidget}>
    {update => <ProfileWidget {...props} update={update} />}
  </Mutation>
)

const DeleteMutation = props => (
  <Mutation mutation={deleteProfileWidget}>
    {deleteWidget => <Mutated {...props} deleteWidget={deleteWidget} />}
  </Mutation>
)

export default compose(withErrorBoundary)(DeleteMutation)
