require_dependency Rails.root.join 'app/serializers/activity/character_serializer'

class Activity::ImageSerializer < ActiveModel::Serializer
  attributes :id,
             :url,
             :title,
             :caption,
             :gravity,
             :comments_count,
             :favorites_count,
             :is_favorite,
             :nsfw

  has_one :character, serializer: Activity::CharacterSerializer

  def id
    object.guid
  end

  def url
    [:small, :small_square, :medium, :medium_square, :large, :large_square].collect do |i|
      [i, object.image.url(i)]
    end.to_h
  end

  def is_favorite
    object.favorites.any? { |f| f.user_id == scope.id } unless scope.nil?
  end
end
