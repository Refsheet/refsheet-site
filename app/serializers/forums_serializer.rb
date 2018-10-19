# == Schema Information
#
# Table name: forums
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  slug        :string
#  locked      :boolean
#  nsfw        :boolean
#  no_rp       :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ForumsSerializer < ActiveModel::Serializer
  attributes :name,
             :description,
             :slug,
             :locked,
             :nsfw,
             :no_rp,
             :group_name,
             :thread_count,
             :path

  def path
    "/forums/#{object.slug}"
  end
end
