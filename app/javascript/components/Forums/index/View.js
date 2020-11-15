import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Main from '../../Shared/Main'
import { StickyContainer } from 'react-sticky'
import { Col, Container, Row } from 'react-materialize'
import Jumbotron from '../../Shared/Jumbotron'
import { Link } from 'react-router-dom'

class View extends Component {
  render() {
    const { forums } = this.props

    return (
      <Main title={'Forums'}>
        <Jumbotron short>
          <h1>Forums</h1>
        </Jumbotron>

        <div className="tab-row-container">
          <div className="tab-row pushpin">
            <div className="container">
              <ul className="tabs">
                <li className={'tab'}>
                  <Link className={''} to="/v2/forums">
                    System Forums
                  </Link>
                </li>
              </ul>
            </div>
          </div>
        </div>

        <Container>
          <div className={'margin-top--large page-header with-search'}>
            <form className={'right page-search'}>
              <input type={'search'} name={'q'} placeholder={'search'} />
            </form>
            <h1>Forums</h1>
          </div>
          <table>
            <thead>
              <tr>
                <th>Forum</th>
                <th>Topics</th>
                <th>Posts</th>
                <th>Last Post</th>
              </tr>
            </thead>
            <tbody>
              {forums.map((forum) => (
                <tr key={forum.id}>
                  <td>
                    <Link to={`/v2/forums/${forum.slug}`}>{forum.name}</Link>
                    <div className={'muted'}>{forum.description}</div>
                    {console.log({ forum })}
                  </td>
                  <td>0</td>
                  <td>0</td>
                  <td>Very Old</td>
                </tr>
              ))}
            </tbody>
          </table>
        </Container>
      </Main>
    )
  }
}

export const forumType = PropTypes.shape({
  slug: PropTypes.string.isRequired,
  name: PropTypes.string.isRequired,
  summary: PropTypes.string,
  description: PropTypes.string,
  system_owned: PropTypes.bool,
  rules: PropTypes.string,
  prepost_message: PropTypes.string,
  open: PropTypes.bool,
})

View.propTypes = {
  forums: PropTypes.arrayOf(forumType),
}

export default View
