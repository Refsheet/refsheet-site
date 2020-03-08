# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  name                  :string
#  username              :string
#  email                 :string
#  password_digest       :string
#  profile               :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  avatar_file_name      :string
#  avatar_content_type   :string
#  avatar_file_size      :bigint
#  avatar_updated_at     :datetime
#  settings              :json
#  type                  :string
#  auth_code_digest      :string
#  parent_user_id        :integer
#  unconfirmed_email     :string
#  email_confirmed_at    :datetime
#  deleted_at            :datetime
#  avatar_processing     :boolean
#  support_pledge_amount :integer          default(0)
#  guid                  :string
#  admin                 :boolean
#  patron                :boolean
#  supporter             :boolean
#  moderator             :boolean
#
# Indexes
#
#  index_users_on_deleted_at      (deleted_at)
#  index_users_on_guid            (guid)
#  index_users_on_parent_user_id  (parent_user_id)
#  index_users_on_type            (type)
#

class UserSerializer < ActiveModel::Serializer
  include RichTextHelper
  include GravatarImageTag::InstanceMethods

  attributes :username,
             :avatar_url,
             :path,
             :link,
             :name,
             :profile_image_url,
             :profile,
             :profile_markup,
             :characters_count,
             :is_admin,
             :is_patron,
             :is_supporter,
             :is_moderator,
             :followed

  has_many :characters,
           serializer: ImageCharacterSerializer

  has_many :character_groups,
           serializer: CharacterGroupSerializer

  def characters
    object.characters.visible_to(scope.current_user).rank(:row_order)
  end

  def characters_count
    object.characters.count
  end

  def path
    "/users/#{object.username}/"
  end

  def link
    "/#{object.username}"
  end

  def profile_markup
    object.profile || ''
  end

  def profile
    linkify profile_markup
  end

  def is_admin
    object.role? :admin
  end

  def is_patron
    object.pledges.active.any?
  end

  def followed
    scope.current_user&.following? object if scope&.respond_to? :current_user
  end
end
