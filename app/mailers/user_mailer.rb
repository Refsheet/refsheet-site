class UserMailer < ApplicationMailer
  def invitation_with_transfers(invitation_id, auth_code)
    @invitation = Invitation.find invitation_id
    @auth_code = auth_code
    @preheader = 'You\'ve got characters! Sign up for Refsheet.net to claim them.'

    if @invitation.transfers.many?
      subject = 'Claim your character transfers!'
    else
      t = @invitation.transfers.first
      subject = "#{t.sender.name} wants to send you a character!"
    end

    mail to: @invitation.email,
         subject: '[Refsheet.net] ' + subject
  end

  def invitation(invitation_id, auth_code)
    @invitation = Invitation.find invitation_id
    @auth_code = auth_code

    mail to: @invitation.email,
         subject: '[Refsheet.net] Invitation to join!'
  end

  def welcome(user_id, auth_code)
    @user = User.find user_id
    @auth_code = auth_code
    @preheader = 'Welcome to Refsheet.net! Please, confirm your email address so we know it is you!'

    return unless allowed? @user, key: :system
    mail to: @user.email_to,
         subject: '[Refsheet.net] Confirm your email'
  end

  def password_reset(user_id, auth_code)
    @user = User.find user_id
    @auth_code = auth_code
    @preheader = 'Somebody (hopefully you) wants to reset a password on Refsheet.'

    return unless allowed? @user, key: :system
    mail to: @user.email_to,
         subject: '[Refsheet.net] Password reset request'
  end

  def email_changed(user_id, auth_code)
    @user = User.find user_id
    @auth_code = auth_code
    @preheader = 'Confirm your new email address, please!'

    return unless allowed? @user, key: :system
    mail to: @user.email_to(@user.unconfirmed_email),
         subject: '[Refsheet.net] Confirm email change'
  end

  def patron_get(user_id)
    @user = User.find user_id
    @preheader = 'Patreon just told me that you are now a supporter of Refsheet, and that is REALLY cool!'

    return unless allowed? @user, key: :system
    mail to: @user.email_to,
         subject: '[Refsheet.net] Thank you for your support!'
  end

  def patron_link(patron, auth_code)
    @patron = patron
    @auth_code = auth_code
    @preheader = 'Confirm your email address to link your Patreon account.'

    return unless allowed? @user, key: :system
    mail to: @patron.email_to,
         subject: '[Refsheet.net] Confirm Patreon Email'
  end
end
