import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Main from '../../Shared/Main'
import { StickyContainer } from 'react-sticky'
import { Col, Container, Row } from 'react-materialize'
import Jumbotron from '../../Shared/Jumbotron'
import { Link } from 'react-router-dom'
import Error from '../../Shared/Error'

class View extends Component {
  render() {
    const { forums } = this.props

    if (!forums) {
      return <Error error={'This forum did not load properly, it seems.'} />
    }

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
                  <Link className={''} to="/forums">
                    System Forums
                  </Link>
                </li>
              </ul>
            </div>
          </div>
        </div>

        <Container>
          <div className={'margin-top--large page-header with-search'}>
            This particular list is under construction. It will change.{' '}
            <u>
              Please ignore that it says there are no recent posts, I promise
              there are probably recent posts.
            </u>
            <br />
            <br />
            This is part of an ongoing effort to improve moderation and security
            in the forums. You see, Refsheet.net has two site administrators
            right now, and we get very sad when we have more work to do than
            necessary. Vector is pretty tired right now, and Mau doesn't really
            have time to moderate with all the coding that they are doing, so
            we're running on a close-to-zero tolerance policy when it comes to
            people being not excellent here.
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
              {forums.map(forum => (
                <tr key={forum.id}>
                  <td>
                    <Link to={`/forums/${forum.slug}`}>{forum.name}</Link>
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
