import React from 'react'
import Error from 'Shared/Error'
import { Row, Col } from 'react-materialize'
import { Mutation } from 'react-apollo'
import updateModeration from 'graphql/mutations/updateModeration.graphql'

import Jumbotron from 'components/Shared/Jumbotron'
import Main from 'v1/shared/Main'
import Spinner from 'v1/shared/material/Spinner'
import Container from 'v1/shared/material/Container'

const Resolution = ({ id, updateModeration, data, loading, error }) => {
  if (loading) {
    return <Spinner />
  }

  const resolve = type => e => {
    e.preventDefault()
    updateModeration({ variables: { id: id, resolution: type } })
  }

  return (
    <div>
      <a
        href="#"
        onClick={resolve('ignore')}
        className="btn grey block grey-text text-darken-2 margin-bottom--medium"
      >
        Ignore
      </a>
      <a
        href="#"
        onClick={resolve('dismiss')}
        className="btn green block white-text margin-bottom--medium"
      >
        No Issue
      </a>
      <a
        href="#"
        onClick={resolve('auto_resolve')}
        className="btn red block white-text"
      >
        Auto Resolve
      </a>
    </div>
  )
}

const View = ({ moderation, refetch }) => {
  if (!moderation) {
    return <Error message="No moderation items in queue" />
  }

  const next = e => {
    e.preventDefault()
    refetch()
  }

  return (
    <Main>
      <Jumbotron className="short">
        <h1>Site Moderation</h1>
      </Jumbotron>

      <Container className="margin-top--large">
        <Row>
          <Col s={12} m={8}>
            <img src={moderation.item.url.medium} className="responsive-img" />
            <p>{moderation.item.caption}</p>
          </Col>

          <Col m={4}>
            <p className="caption white-text">{moderation.violationMessage}</p>
            {moderation.comment && (
              <p className="muted">Comment: {moderation.comment}</p>
            )}

            <ul>
              <li>User: @{moderation.user.username}</li>
              <li>Hidden: {moderation.item.hidden ? 'yes' : 'no'}</li>
              <li>NSFW: {moderation.item.nsfw ? 'yes' : 'no'}</li>
              <li>Source: {moderation.item.source_url}</li>
            </ul>

            {moderation.status === 'pending' && (
              <Mutation mutation={updateModeration}>
                {(resolve, data) => (
                  <Resolution
                    id={moderation.id}
                    updateModeration={resolve}
                    {...data}
                  />
                )}
              </Mutation>
            )}

            {moderation.status !== 'pending' && (
              <div>
                Resolved: {moderation.status}
                <a
                  href="#"
                  onClick={next}
                  className="btn block margin-top--medium white-text"
                >
                  Next
                </a>
              </div>
            )}
          </Col>
        </Row>
      </Container>
    </Main>
  )
}

export default View
