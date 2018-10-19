module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user
      Rails.logger.info("Looking up user by #{cookies.signed[:user_id].inspect}")
      if (current_user = User.find_by(id: cookies.signed[:user_id]))
        Rails.logger.info("Found #{current_user.name}")
        current_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
