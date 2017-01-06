class UserSerializer < ActiveModel::Serializer
  include RichTextHelper
  include GravatarImageTag::InstanceMethods

  attributes :username, :email, :avatar_url, :path, :name, :profile_image_url, :cover_image_url, :profile

  has_many :characters, serializer: ImageCharacterSerializer

  def avatar_url
    gravatar_image_url object.email
  end

  def profile_image_url
    '/assets/unsplash/fox.jpg'
  end

  def cover_image_url
    '/assets/unsplash/sand.jpg'
  end

  def path
    "/users/#{object.username}/"
  end

  def profile
    linkify <<-MARKDOWN
# Hey there!
So profiles are comoing soon (I promise!). I just need to figure out how to lay them out. User chips are coming
very soon though, @MauAbata will fix it. His character, @MauAbata/akhet isn't a programmer though.

#<center>@@MauAbata+Inkmaven</center>
    MARKDOWN
  end
end
