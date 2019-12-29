# == Schema Information
#
# Table name: forum_karmas
#
#  id          :integer          not null, primary key
#  karmic_id   :integer
#  karmic_type :string
#  user_id     :integer
#  discord     :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  value       :integer          default(1)
#
# Indexes
#
#  index_forum_karmas_on_karmic_id    (karmic_id)
#  index_forum_karmas_on_karmic_type  (karmic_type)
#

require 'rails_helper'

describe Forum::Karma, type: :model do
  it_is_expected_to(
      belong_to: [
          :karmic,
          :user
      ],
      validate_presence_of: [
          :karmic,
          :user,
          :value
      ]
  )

  it 'accepts 1 karma per user' do
    user = create :user
    post1 = create :forum_post
    post2 = create :forum_post

    k1 = Forum::Karma.create(karmic: post1, user: user, value: 1)
    k2 = Forum::Karma.create(karmic: post2, user: user, value: -1)
    k3 = Forum::Karma.create(karmic: post2, user: user, value: 1)

    expect(k1).to be_valid
    expect(k2).to be_valid
    expect(k3).to_not be_valid
  end

  it 'destroys karma for user' do
    user = create :user
    post = create :forum_post
    k1 = Forum::Karma.create(karmic: post, user: user, value: -1)

    expect(post).to have(1).karmas
    post.karmas.for_user(user).destroy_all
    expect(post).to have(0).karmas
  end
end
