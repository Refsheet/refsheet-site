import React from 'react'
import { Icon } from 'react-materialize'

export const Loading = () => (
  <div className={'image-status loading'}>
    <Icon>hourglass_empty</Icon>
    <h2>Loading...</h2>
  </div>
)

export const Error = ({ error }) => (
  <div className={'image-status loading'}>
    <Icon>warning</Icon>
    <h2>Error!</h2>
    {error && <div className={'muted margin-top--large'}>{error}</div>}
  </div>
)
