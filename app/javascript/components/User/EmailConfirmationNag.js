import React, { useState } from 'react'
import { withCurrentUser, withMutations } from '../../utils/compose'
import Button from '../Styled/Button'
import gql from 'graphql-tag'

const RESEND_EMAIL_CONFIRMATION = gql`
  mutation resendEmailConfirmation {
    resendEmailConfirmation {
      id
      email_confirmed_at
      unconfirmed_email
    }
  }
`

const EmailConfirmationNag = ({
  currentUser,
  permit,
  resendEmailConfirmation,
  nosend = false,
  children = null,
}) => {
  if (
    permit ||
    (currentUser.email_confirmed_at && !currentUser.unconfirmed_email)
  ) {
    return children
  }

  let [loading, setLoading] = useState(false)
  let [sent, setCalled] = useState(false)
  let validation = null

  const handleSend = e => {
    e.preventDefault()
    resendEmailConfirmation({
      wrapped: true,
      setLoading,
      setCalled,
    })
  }

  if (!nosend) {
    validation = (
      <>
        <p className={'margin--none right'} style={{ lineHeight: '2.5rem' }}>
          We sent a validation email to{' '}
          <strong>{currentUser.unconfirmed_email || currentUser.email}</strong>.
        </p>
        <Button error disabled={loading || sent} onClick={handleSend}>
          {loading ? 'Sending...' : sent ? 'Email sent.' : 'Resend Email?'}
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

export default withMutations({
  resendEmailConfirmation: RESEND_EMAIL_CONFIRMATION,
})(withCurrentUser()(EmailConfirmationNag))
