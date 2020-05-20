module Users
  class MergeUserJob < ApplicationJob
    def perform(target_user_id:, source_user_ids:)
      user_id_classes = [
          Character,
          Activity,
          ApiKey,
          Artist,
          BankAccount,
          Bid,
          BlockedUser,
          Changelog,
          CharacterGroup,
          ColorScheme,
          Feedback,
          Invitation,
          ModerationReport,
          Notification,
          Order,
          Permission,
          Seller,
      ]

      other_classes = {
          BlockedUser => [:blocked_user_id],
          Changelog => [:changed_user_id],
          Conversation => [:sender_id, :recipient_id],
          Item => [:seller_user_id],
          ModerationReport => [:sender_user_id],
          Notification => [:sender_user_id],
          Organization => [:parent_user_id],
          Transfer => [:sender_user_id, :destination_user_id],
      }

      # Go through and force-update user IDs to match the new user:
      user_id_classes.each do |klass|
        klass.where(user_id: source_user_ids).update_all(user_id: target_user_id)
      end

      other_classes.each do |klass, columns|
        columns.each do |column|
          klass.where(column => source_user_ids).update_all(column => target_user_id)
        end
      end

      User.unscoped.where(id: source_user_ids).delete_all
    end
  end
end