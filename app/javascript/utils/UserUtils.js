import c from 'classnames'

export const userClasses = (user, className = 'user-color', ) => {
  if(!user) { return '' }
  return c(className, {
    admin: user.is_admin,
    patron: user.is_patron
  })
}
