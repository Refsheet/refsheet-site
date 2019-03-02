module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user
      if defined? cookies and cookies[UserSession::COOKIE_SESSION_TOKEN_NAME]
        Rails.logger.info("Looking up user by #{cookies.signed[UserSession::COOKIE_SESSION_TOKEN_NAME].inspect}")
        get_remembered_user
      end

      if defined? cookies and (user_id = cookies.signed[UserSession::COOKIE_USER_ID_NAME])
        Rails.logger.info("Looking up user by user_id cookie: #{user_id}")
        @current_user ||= User.find_by id: user_id
      else
        reject_unauthorized_connection
      end
    end

    def get_remembered_user
      if cookies[UserSession::COOKIE_SESSION_ID_NAME] && cookies[UserSession::COOKIE_USER_ID_NAME]
        session = UserSession.find_by(session_guid: cookies[UserSession::COOKIE_SESSION_ID_NAME])

        if session &&
            session.user_id == cookies[UserSession::COOKIE_USER_ID_NAME] &&
            session.authenticate(cookies[UserSession::COOKIE_SESSION_TOKEN_NAME])
          Rails.logger.info("Authenticating user #{session.user_id} from stored session cookie.")
          sign_in(session.user, remember: false)
          return session.user
        end
      end
    end
  end
end
