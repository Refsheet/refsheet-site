module Users::AuthCodeDecorator
  EMAIL_CONFIRMATION_EXPIRES_AT = 1.week.freeze
  ACCOUNT_RECOVERY_EXPIRES_AT = 1.day.freeze
  OTP_LOGIN_EXPIRES_AT = 1.hour.freeze
  EMAIL_CHANGE_EXPIRES_AT = 1.week.freeze

  def auth_expired?(timestamp, expiration)
    if timestamp.nil?
      return true
    end

    if (Time.zone.now - timestamp) > expiration
      return true
    end

    false
  end

  def start_email_confirmation!
    if auth_expired? email_confirmation_created_at, EMAIL_CONFIRMATION_EXPIRES_AT
      auth_code = SecureRandom.base58
      update_columns email_confirmation_token: auth_code,
                     email_confirmation_created_at: Time.zone.now
    end

    UserMailer.welcome(self.id, auth_code).deliver_later!
    auth_code
  end

  def check_email_confirmation?(auth_code)
    return false unless email_confirmation_token.present?
    return false if auth_expired? email_confirmation_created_at, EMAIL_CONFIRMATION_EXPIRES_AT

    if email_confirmation_token == auth_code
      update_columns email_confirmation_token: nil, email_confirmation_created_at: nil
      return true
    end
    false
  end

  def start_email_change!
    if auth_expired? email_change_created_at, EMAIL_CHANGE_EXPIRES_AT
      auth_code = SecureRandom.base58
      update_columns email_change_token: auth_code,
                     email_change_created_at: Time.zone.now
    end

    UserMailer.email_changed(self.id, auth_code).deliver_later!
    auth_code
  end

  def check_email_change?(auth_code)
    return false unless email_change_token.present?
    return false if auth_expired? email_change_created_at, EMAIL_CHANGE_EXPIRES_AT

    if email_change_token == auth_code
      update_columns email_change_token: nil, email_change_created_at: nil
      return true
    end
    false
  end

  def start_account_recovery!
    auth_code = ("%06d" % SecureRandom.random_number(1e6))
    update_columns account_recovery_token: BCrypt::Password.create(auth_code),
                   account_recovery_created_at: Time.zone.now

    UserMailer.password_reset(self.id, auth_code).deliver_later!
    auth_code
  end

  def check_account_recovery?(auth_code)
    return false unless account_recovery_token.present?
    return false if auth_expired? account_recovery_created_at, ACCOUNT_RECOVERY_EXPIRES_AT

    if BCrypt::Password.new(account_recovery_token) == auth_code
      update_columns account_recovery_token: nil, account_recovery_created_at: nil
      return true
    end
    false
  end

  def start_otp_login!
    auth_code = ("%06d" % SecureRandom.random_number(1e6))
    update_columns otp_login_token: BCrypt::Password.create(auth_code),
                   otp_login_created_at: Time.zone.now

    # UserMailer.otp_login(self.id, auth_code).deliver_later!
    auth_code
  end

  def check_otp_login?(auth_code)
    return false unless otp_login_token.present?
    return false if auth_expired? otp_login_created_at, OTP_LOGIN_EXPIRES_AT

    if BCrypt::Password.new(otp_login_token) == auth_code
      update_columns otp_login_token: nil, otp_login_created_at: nil
      return true
    end
    false
  end


  #== LEGACY

  def confirmed?
    email_confirmed_at.present?
  end

  def confirm!
    @permit_email_swap = true
    email = self.unconfirmed_email || self.email
    update! email_confirmed_at: Time.zone.now, email: email, auth_code_digest: nil, unconfirmed_email: nil
    @permit_email_swap = false
    claim_invitations
  end

  def auth_code?(cleartext)
    ActiveSupport::Deprecation.warn("Use individual authentications.")
    return false unless auth_code_digest.present?
    BCrypt::Password.new(auth_code_digest) == cleartext
  end

  def generate_auth_code!(number=false)
    ActiveSupport::Deprecation.warn("Use individual authentications.")

    auth_code = if number
                  ("%06d" % SecureRandom.random_number(1e6))
                else
                  SecureRandom.base58
                end

    update_columns auth_code_digest: BCrypt::Password.create(auth_code)
    auth_code
  end

  def send_welcome_email
    start_email_confirmation!
  end

  def send_email_change_notice(force = false)
    if @send_email_change_notice or force
      @send_email_change_notice = false
      start_email_change!
    end
  end

  private

  def downcase_email
    self.email&.downcase!
  end

  def handle_email_change
    if !@permit_email_swap and changes.include? :email and changes[:email][0].present?
      return if changes[:email][0].downcase == changes[:email][1].downcase
      self.unconfirmed_email = self.changes[:email][1]
      self.email = self.changes[:email][0]
      @send_email_change_notice = true
    end
  end
end
