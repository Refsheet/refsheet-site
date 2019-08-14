module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      Rails.logger.tagged "Action Cable Connect" do
        self.current_user = find_verified_user
      end
    end

    protected

    def find_verified_user
      if defined?(cookies)
        session_token = cookies.signed[UserSession::COOKIE_SESSION_TOKEN_NAME]
        insecure_user_id = cookies.signed[UserSession::COOKIE_USER_ID_NAME]
        Rails.logger.info("Cookies: #{cookies.to_h.inspect}")
      else
        return reject_unauthorized_connection
      end

      Rails.logger.warn("#{UserSession::COOKIE_SESSION_TOKEN_NAME.inspect}: #{session_token.inspect}, " +
                        "#{UserSession::COOKIE_USER_ID_NAME.inspect}: #{insecure_user_id.inspect}")

      if !session_token.nil?
        Rails.logger.info("Looking up user by session_token: #{session_token.inspect}")
        user = get_remembered_user(session_token, insecure_user_id)
      elsif !insecure_user_id.nil?
        Rails.logger.info("Looking up user by insecure_user_id: #{insecure_user_id.inspect}")
        user = User.find_by id: insecure_user_id
      else
        Rails.logger.warn("Session Token and IUID is nil: #{session_token.inspect}, #{insecure_user_id.inspect}")
        return reject_unauthorized_connection
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
