import React from 'react'
import Main from '../../Shared/Main'
import { Link } from 'react-router-dom'

const View = ({ data: { artists, currentPage, perPage } }) => {
  return (
    <Main title={'Artists'}>
      <div className={'container'}>
        <ul>
          {artists.map(artist => (
            <li key={artist.slug}>
              <Link to={`/artists/${artist.slug}`}>{artist.name}</Link>
            </li>
          ))}
        </ul>
      </div>
    </Main>
  )
}

export default View
