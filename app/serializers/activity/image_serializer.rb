class Activity::ImageSerializer < ActiveModel::Serializer
  attributes :id,
             :url,
             :title,
             :caption,
             :gravity#,
             # :comments_count,
             # :favorites_count

  def id
    object.guid
  end

  def url
    [:small, :small_square, :medium, :medium_square, :large, :large_square].collect do |i|
      [i, object.image.url(i)]
    end.to_h
  end
end
