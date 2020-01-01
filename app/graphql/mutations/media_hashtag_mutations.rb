class Mutations::MediaHashtagMutations < Mutations::ApplicationMutation
  action :autocomplete do
    type types[Types::MediaHashtagType]

    argument :hashtag, !types.String
  end

  def autocomplete
    query = params[:hashtag]&.to_s&.downcase + '%'
    @hashtags = Media::Hashtag.where('LOWER(media_hashtags.tag) LIKE ?', query)
  end
end
