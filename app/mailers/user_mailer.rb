class UserMailer < ApplicationMailer
  def invitation_with_transfers(invitation_id, auth_code)
    @invitation = Invitation.find invitation_id
    @auth_code = auth_code

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

  def welcome(user_id)

  end

  def password_reset(user_id, auth_code)

  end
end
