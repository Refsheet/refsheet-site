# == Schema Information
#
# Table name: user_followers
#
#  id           :integer          not null, primary key
#  following_id :integer
#  follower_id  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_user_followers_on_follower_id   (follower_id)
#  index_user_followers_on_following_id  (following_id)
#

class User::Follower < ApplicationRecord
  belongs_to :following, class_name: User
  belongs_to :follower, class_name: User

  def self.suggested(follower=nil)
    follower ||= self.new.following || self.new.follower
    raise ArgumentError.new 'Follower cannot be new. Did you mean to call this from an association?' unless follower

    f =  sanitize_sql_array [<<-SQL.squish, follower.id, follower.id]
            SELECT uf2.following_id as following_id, COUNT(*) as mutuals
            FROM user_followers uf1      
            JOIN user_followers uf2 ON uf2.follower_id = uf1.following_id
            AND NOT EXISTS(
                SELECT 1 FROM user_followers uf3
                WHERE uf3.follower_id = ?
                AND uf3.following_id = uf2.following_id
            )
            WHERE uf1.follower_id = ?
            GROUP BY uf2.following_id
        SQL

    User
        .select('users.*, ufi.mutuals AS mutuals')
        .joins("JOIN (#{f}) ufi ON ufi.following_id = users.id")
        .order('ufi.mutuals DESC')
  end
end
