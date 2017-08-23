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

class Forum < ApplicationRecord
end
