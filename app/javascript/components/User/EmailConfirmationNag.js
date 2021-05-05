import React from 'react'
import { withCurrentUser } from '../../utils/compose'
import Button from '../Styled/Button'

const EmailConfirmationNag = ({ currentUser, permit, children = null }) => {
  if (
    permit ||
    (currentUser.email_confirmed_at && !currentUser.unconfirmed_email)
  ) {
    return children
  }

  let validation = null

  if (false) {
    validation = (
      <>
        <p className={'margin--none right'} style={{ lineHeight: '2.5rem' }}>
          We sent a validation email to{' '}
          <strong>{currentUser.unconfirmed_email || currentUser.email}</strong>.
        </p>
        <Button error onClick={() => false}>
          Resend Email?
        </Button>
      </>
    )
  }

  return (
    <div className={'card-panel red darken-3 white-text'}>
      <p>
        <strong>Your email address is unconfirmed.</strong>
      </p>
      <p>
        Some site features may not be available until you confirm your email
        address. Confirming your email address is important, since it allows us
        to contact you for account-related information, as well as recovery for
        your account if you lose your password.
      </p>
      {validation}
    </div>
  )
}

export default withCurrentUser()(EmailConfirmationNag)
