#  id              :integer          not null, primary key
#  guid            :string
#  user_id         :integer
#  character_id    :integer
#  activity_type   :string
#  activity_id     :integer
#  activity_method :string
#  activity_field  :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null

class InitializeActivities < ActiveRecord::Migration[5.0]
  def up
    characters = Character
                     .pluck(:id, :user_id, :created_at)
                     .collect { |i| %w(activity_id user_id created_at).zip(i).to_h.merge(activity_type: 'Character', activity_method: 'create') }

    images = Image
                 .joins(:character => :user)
                 .pluck(:id, :character_id, 'users.id', :created_at)
                 .collect { |i| %w(activity_id character_id user_id created_at).zip(i).to_h.merge(activity_type: 'Image', activity_method: 'create') }

    discussions = Forum::Discussion
                      .pluck(:id, :user_id, :created_at)
                      .collect { |i| %w(activity_id user_id created_at).zip(i).to_h.merge(activity_type: 'Forum::Discussion', activity_method: 'create') }

    comments = Media::Comment
                   .pluck(:id, :user_id, :created_at)
                   .collect { |i| %w(activity_id user_id created_at).zip(i).to_h.merge(activity_type: 'Media::Comment', activity_method: 'create') }

    activities = characters + images + discussions + comments

    Activity.create activities
  end

  def down
    Activity.delete_all
  end
end
