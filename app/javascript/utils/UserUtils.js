import c from 'classnames'

export const USER_FG_COLOR = {
  admin: '#2480C8',
  patron: '#F96854',
  moderator: '#B298DC',
  supporter: '#C95D63',
}

export const USER_BG_COLOR = {
  admin: '#030a0f',
  patron: '#0f0404',
  moderator: '#0c050f',
  supporter: '#0f0505',
}

export const userClasses = (user, className = 'user-color') => {
  if (!user) {
    return ''
  }
  return c(className, {
    admin: user.is_admin,
    patron: user.is_patron,
  })
}

export const userFgColor = ({
  is_admin,
  is_patron,
  is_moderator,
  is_supporter,
}) => {
  if (is_admin) return USER_FG_COLOR.admin
  if (is_moderator) return USER_FG_COLOR.moderator
  if (is_patron) return USER_FG_COLOR.patron
  if (is_supporter) return USER_FG_COLOR.supporter
}

export const userBgColor = ({
  is_admin,
  is_patron,
  is_moderator,
  is_supporter,
}) => {
  return undefined
  if (is_admin) return USER_BG_COLOR.admin
  if (is_moderator) return USER_BG_COLOR.moderator
  if (is_patron) return USER_BG_COLOR.patron
  if (is_supporter) return USER_BG_COLOR.supporter
}
