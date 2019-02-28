import React, { Component } from 'react';
import PropTypes from 'prop-types';
import ProfileColumn from './ProfileColumn';
import Section from 'Shared/Section';
import c from 'classnames';
import {Mutation} from "react-apollo";
import { gql } from 'apollo-client-preset'

class ProfileSection extends Component {
  constructor(props) {
    super(props)

    this.handleTitleChange = this.handleTitleChange.bind(this)
  }

  handleTitleChange(title) {
    this.props.updateSection({
      variables: {
        id: this.props.id,
        title
      }
    })
      .then((data) => {
        console.log(data)
      })
      .catch((error) => console.error(error))
  }

  renderSectionColumns(columns, widgets, editable) {
    return columns.map(function(width, id) {
      const columnWidgets = widgets.filter(w => w.column === id)

      return <ProfileColumn key={id}
                            id={id}
                            width={width}
                            widgets={columnWidgets}
                            editable={editable} />
    })
  }

  render() {
    const {id, title, columns, widgets, editable, className} = this.props
    console.log(this.props)

    return (
      <Section title={title} className={ c('margin-bottom--large', className) } editable={editable} onTitleChange={this.handleTitleChange}>
        <div className='row margin-top--medium'>
          { this.renderSectionColumns(columns, widgets, editable) }
        </div>
      </Section>
    )
  }
}

ProfileSection.prototype.propTypes = {
  columns: PropTypes.array.isRequired,
  id: PropTypes.string.isRequired,
  title: PropTypes.string,
  onChange: PropTypes.func,
  editable: PropTypes.bool,
  className: PropTypes.string
};

const UPDATE_SECTION_MUTATION = gql`
  mutation updateProfileSection($id: ID!, $title: String) {
      updateProfileSection(id: $id, title: $title) {
          title
      }
  }
`

const Wrapped = (props) => (
  <Mutation mutation={UPDATE_SECTION_MUTATION}>
    {(updateSection, {mutationData}) => (
      <ProfileSection {...props} updateSection={updateSection} mutationData={mutationData} />
    )}
  </Mutation>
)

export default Wrapped;
