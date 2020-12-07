import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { withTranslation } from 'react-i18next'
import compose from 'utils/compose'
import { H1 } from 'Styled/Headings'
import styled from 'styled-components'
import { withRouter } from 'react-router'
import FormUtils from '../../../utils/FormUtils'
import LinkUtils from '../../../utils/LinkUtils'

import Icon from 'v1/shared/material/Icon'

class SearchForm extends Component {
  constructor(props) {
    super(props)

    this.state = {
      search: {
        query: props.query,
      },
    }

    this.handleInputChange = FormUtils.handleInputChange('search').bind(this)
  }

  handleSubmit(e) {
    e.preventDefault()

    const {
      forum: { slug: forumId },
      history,
    } = this.props
    const {
      search: { query: q },
    } = this.state

    const path = LinkUtils.forumPath({ forumId }, { q })
    history.push(path)
  }

  render() {
    const { t } = this.props

    return (
      <form
        className={this.props.className}
        onSubmit={this.handleSubmit.bind(this)}
      >
        <input
          id={'forum_query'}
          type={'search'}
          name={'query'}
          value={this.state.search.query}
          placeholder={t('forums.search_label', 'Search Posts...')}
          onChange={this.handleInputChange}
        />
        <button className={'btn btn-flat'} type={'submit'}>
          <Icon>search</Icon>
        </button>
      </form>
    )
  }
}

SearchForm.propTypes = {}

// TODO: Should I only use styled for theme application, and move the rest into a .sass that lives
//       alongside this component in the JS tree? Or leave it all here?
const withStyle = c => styled(c)`
  display: flex;
  height: 40px;
  margin: 4px 0;

  input[type='search']:not(.browser-default) {
    background-color: ${props => props.theme.cardHeaderBackground};
    border: 1px solid ${props => props.theme.border};
    border-right: none;
    border-radius: 2px;
    border-top-right-radius: 0;
    border-bottom-right-radius: 0;
    box-sizing: border-box;
    flex-grow: 1;
    flex-shrink: 1;
    height: 40px;
    line-height: 40px;
    margin: 0;
    padding: 0 1rem;

    &:focus:not([readonly]) {
      background-color: ${props => props.theme.cardHeaderBackground};
      border: 1px solid ${props => props.theme.border};
      border-bottom-color: ${props => props.theme.primary};
      box-shadow: 0 1px 0 0 ${props => props.theme.primary};
      border-right: none;

      & + button {
        border-bottom-color: ${props => props.theme.primary};
        box-shadow: 0 1px 0 0 ${props => props.theme.primary};
      }
    }
  }

  button {
    background-color: ${props => props.theme.cardHeaderBackground};
    border: 1px solid ${props => props.theme.border};
    border-left: none;
    border-radius: 2px;
    border-bottom-left-radius: 0;
    border-top-left-radius: 0;
    box-sizing: border-box;
    flex-grow: 0;
    flex-shrink: 0;
    height: 40px;
    line-height: 40px;
    margin: 0;
    padding: 0 1rem;
    transition: box-shadow 0.3s, border 0.3s;

    &:hover {
      background-color: ${props => props.theme.secondary};
    }
  }
`

export default compose(
  withTranslation('common'),
  withStyle,
  withRouter
)(SearchForm)
