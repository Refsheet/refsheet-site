import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { camelize } from 'object-utils'
import widgets, { SerializerWidget } from './Widgets'
import ProfileWidgetHeader from "./ProfileWidgetHeader";
import {Mutation} from "react-apollo";
import updateProfileWidget from './updateProfileWidget.graphql'

class ProfileWidget extends Component {
  constructor(props) {
    super(props)

    this.state = {
      editing: false,
      widgetData: props.data,
      headerData: {
        title: props.title
      }
    }

  }

  handleEditStart() {
    this.setState({editing: true})
  }

  handleEditStop() {
    this.setState({editing: false})
  }

  handleSave() {
    const payload = {
      id: this.props.id,
      data: JSON.stringify(this.state.widgetData),
      title: this.state.headerData.title
    }

    console.log("EMITTING WIDGET DATA:", {payload})

    this.props.update({variables: payload})
      .then((data) => {
        const { updateProfileWidget: widgetData } = data

        this.props.onChange && this.props.onChange(widgetData)
        this.handleEditStop()
      })
      .catch((error) => console.error(error))
  }

  handleWidgetChange(widgetData) {
    this.setState({widgetData})
  }

  render() {
    const {widgetType, title, data, editable} = this.props
    const Widget = widgets[widgetType] || SerializerWidget;

    return (
      <div className='card profile-widget margin--none'>
        <ProfileWidgetHeader
          widgetType={widgetType}
          title={title}
          editable={editable}
          editing={this.state.editing}
          onEditStart={this.handleEditStart.bind(this)}
          onEditStop={this.handleEditStop.bind(this)}
          onSave={this.handleSave.bind(this)}
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
  update: PropTypes.func.isRequired
}

const Mutated = (props) => (
  <Mutation mutation={updateProfileWidget}>
    {(update, {data}) => <ProfileWidget {...props} mutationData={data} update={update} />}
  </Mutation>
)

export default Mutated
