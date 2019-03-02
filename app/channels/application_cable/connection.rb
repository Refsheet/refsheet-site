module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user
      user = nil

      if defined?(cookies)
        Rails.logger.info("Cookies: #{cookies.to_h.inspect}")
      end

      session_token = defined?(cookies) && cookies.signed[UserSession::COOKIE_SESSION_TOKEN_NAME]
      insecure_user_id = defined?(cookies) && cookies.signed[UserSession::COOKIE_USER_ID_NAME]

      if session_token
        Rails.logger.info("Looking up user by session_token: #{session_token.inspect}")
        user = get_remembered_user(session_token, insecure_user_id)
      elsif insecure_user_id
        Rails.logger.info("Looking up user by insecure_user_id: #{insecure_user_id.inspect}")
        user = User.find_by id: user_id
      else
        Rails.logger.warn("Session Token and IUID is nil!")
      end

      Rails.logger.info("possible user: #{user}")

      if user
        user
      else
        reject_unauthorized_connection
      end
    end

    def get_remembered_user(session_token, user_id)
      session_id = cookies.signed[UserSession::COOKIE_SESSION_ID_NAME]

      if session_id && user_id
        session = UserSession.find_by(session_guid: session_id)

        if session
          Rails.logger.info("Session # #{session.id} found!")

          if session.user_id == user_id && session.authenticate(session_token)
            return session.user
          end
        else
          Rails.logger.warn("No matching session found.")
        end
      end

      false
    end
  end
end
