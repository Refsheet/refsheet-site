import React from 'react'
import { Link } from 'react-router-dom'

import Follow from 'v1/views/user/Follow'

const UserCard = ({ smaller, user, onFollow }) => {
  let imgShadow, nameColor
  const nameClassNames = ['strong truncate']

  if (!smaller) {
    nameClassNames.push('larger')
  }
  const nameLh = smaller ? '1.5rem' : '2rem'
  const imgMargin = smaller ? '0 0.5rem 0 0' : '0.5rem 1rem 0.5rem 0'

  if (user.is_admin) {
    imgShadow = '0 0 3px 1px #2480C8'
    nameColor = '#2480C8'
  } else if (user.is_patron) {
    imgShadow = '0 0 3px 1px #F96854'
    nameColor = '#F96854'
  }

  return (
    <div className="user-summary" style={{ height: '2.5rem' }}>
      <img
        src={user.avatar_url}
        alt={user.username}
        className="circle left"
        style={{
          width: '3rem',
          height: '3rem',
          margin: imgMargin,
          boxShadow: imgShadow,
        }}
      />

      <div className="user-details">
        {onFollow && (
          <Follow
            username={user.username}
            followed={user.followed}
            short={smaller}
            onFollow={onFollow}
          />
        )}

        <Link
          to={`/${user.username}`}
          className={nameClassNames.join(' ')}
          style={{ lineHeight: nameLh, color: nameColor }}
        >
          {user.name}
        </Link>

        <div className="truncate lighter" style={{ lineHeight: '1.5rem' }}>
          @{user.username}
        </div>
      </div>
      <div className="clearfix" />
    </div>
  )
}

export default UserCard
