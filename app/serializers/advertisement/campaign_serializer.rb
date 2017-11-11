class Advertisement::CampaignSerializer < ActiveModel::Serializer
  attributes :id,
             :title,
             :caption,
             :slug,
             :image_url,
             :link,
             :current_slot_id

  def id
    object.guid
  end

  def image_url
    {
        medium: object.image.url(:medium),
        large: object.image.url(:large)
    }
  end
end
