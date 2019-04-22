import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { camelize } from 'object-utils'
import widgets, { SerializerWidget } from './Widgets'
import ProfileWidgetHeader from "./ProfileWidgetHeader";
import {Mutation} from "react-apollo";
import updateProfileWidget from './updateProfileWidget.graphql'
import deleteProfileWidget from './deleteProfileWidget.graphql'
import * as M from "materialize-css";

class ProfileWidget extends Component {
  constructor(props) {
    super(props)

    this.state = {
      editing: false,
      widgetData: props.data
    }
  }

  handleEditStart() {
    this.setState({editing: true})
  }

  handleEditStop() {
    this.setState({editing: false})
  }

  handleDelete() {
    const payload = {
      id: this.props.id
    }

    this.props.deleteWidget({variables: payload})
      .then(({data, errors}) => {
        if (errors) {
          console.error(errors)
          errors.map((e) => M.toast({html: e.message, classes: 'red', duration: 3000}))
        } else {
          const { deleteProfileWidget: widgetData } = data
          this.props.onDelete && this.props.onDelete(widgetData.id)
        }
      })
      .catch((error) => console.error(error))
  }

  handleMove(direction) {
    const payload = {
      id: this.props.id
    }

    if (direction === 'up' || direction === 'down') {
      payload['row_order_position'] = direction
    } else if (direction === 'left') {
      payload['column'] = this.props.column - 1
    } else if (direction === 'right') {
      payload['column'] = this.props.column + 1
    }

    this.props.update({variables: payload})
      .then(({data, errors}) => {
        if (errors) {
          console.error(errors)
          errors.map((e) => M.toast({html: e.message, classes: 'red', duration: 3000}))
        } else {
          const { updateProfileWidget: widgetData } = data
          this.props.onChange && this.props.onChange(widgetData)
        }
      })
      .catch((error) => console.error(error))
  }

  handleSave(title) {
    const payload = {
      id: this.props.id,
      data: JSON.stringify(this.state.widgetData),
      title: title
    }

    this.props.update({variables: payload})
      .then(({data, errors}) => {
        if (errors) {
          console.error(errors)
          errors.map((e) => M.toast({html: e.message, classes: 'red', duration: 3000}))
        } else {
          const {updateProfileWidget: widgetData} = data

          this.props.onChange && this.props.onChange(widgetData)
          this.handleEditStop()
        }
      })
      .catch((error) => console.error(error))
  }

  handleWidgetChange(widgetData) {
    this.setState({widgetData})
  }

  render() {
    const {widgetType, title, data, editable, lastColumn, firstColumn, first, last} = this.props
    const Widget = widgets[widgetType] || SerializerWidget;

    return (
      <div className='card profile-widget margin-top--none margin-bottom--large margin-bottom-last--none'>
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
          lastColumn={lastColumn}
          firstColumn={firstColumn}
          first={first}
          last={last}
        />

        <Widget
          {...camelize(data)}
          onChange={this.handleWidgetChange.bind(this)}
          editing={this.state.editing}
        />
      </div>
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
  last: PropTypes.bool
}

const Mutated = (props) => (
  <Mutation mutation={updateProfileWidget}>
    {(update) => <ProfileWidget {...props} update={update} />}
  </Mutation>
)

const DeleteMutation = (props) => (
  <Mutation mutation={deleteProfileWidget}>
    {(deleteWidget) => <Mutated {...props} deleteWidget={deleteWidget} />}
  </Mutation>
)

export default DeleteMutation
