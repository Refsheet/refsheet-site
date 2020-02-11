# == Schema Information
#
# Table name: forums
#
#  id              :integer          not null, primary key
#  name            :string
#  description     :text
#  slug            :string
#  locked          :boolean
#  nsfw            :boolean
#  no_rp           :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  system_owned    :boolean          default(FALSE)
#  rules           :text
#  prepost_message :text
#  owner_id        :integer
#  fandom_id       :integer
#  open            :boolean          default(FALSE)
#
# Indexes
#
#  index_forums_on_fandom_id     (fandom_id)
#  index_forums_on_owner_id      (owner_id)
#  index_forums_on_slug          (slug)
#  index_forums_on_system_owned  (system_owned)
#

require 'rails_helper'

describe Forum, type: :model do
  it_is_expected_to(
      have_many: [
          :threads,
          :posts
      ],
      validate_presence_of: [
          :name,
          :slug
      ]
  )
end
