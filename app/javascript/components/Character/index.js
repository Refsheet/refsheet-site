/* eslint-disable
    constructor-super,
    no-constant-condition,
    no-this-before-super,
    no-unused-vars,
    react/jsx-no-undef,
    react/prop-types,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS001: Remove Babel/TypeScript constructor workaround
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React, { Component } from 'react';
import View from './View';
import { Error } from 'Shared';
import PropTypes from 'prop-types';
import { graphql } from 'react-apollo';
import { getCharacterProfile } from 'queries/getCharacterProfile.graphql';
import {connect} from "react-redux";

class Character extends Component {
  constructor(props) {
    {
      // Hack: trick Babel/TypeScript into allowing this before super.
      if (false) { super(); }
      let thisFn = (() => { return this; }).toString();
      let thisName = thisFn.match(/return (?:_assertThisInitialized\()*(\w+)\)*;/)[1];
      eval(`${thisName} = this;`);
    }
    this.refetch = this.refetch.bind(this);
    super(props);

    this.state =
      {editable: false};
  }

  refetch() {
    return this.props.data.refetch();
  }

  render() {
    const { data } = this.props;

    if (data.loading) {
      return <Loading />;
    } else if (data.error) {
      const message = data.error.graphQLErrors.map(e => e.message).join(', ');
      return <Error message={message} />;
    } else {
      return <View refetch={this.refetch}
             character={data.getCharacterByUrl}
             {...this.state}
      />;
    }
  }
}

const mapStateToProps = ({uploads}) => ({
  files: uploads.files
});

const Connected = connect(mapStateToProps)(Character);

export default graphql(
  getCharacterProfile, {
  options(props) {
    return {variables: props.match.params};
  }
}
)(Connected);
