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
    Character.select(:id, :user_id, :created_at).find_in_batches do |batch|
      puts "   --> Running #{batch.first.class.name} batch of #{batch.count}"

      activities = batch.collect { |i| {
          activity_id: i.id,
          user_id: i.user_id,
          created_at: i.created_at,
          activity_type: 'Character',
          activity_method: 'create'
      } }

      Activity.create activities
    end

    Image.joins(:character).select(:id, :character_id, 'characters.user_id AS user_id', :created_at).find_in_batches do |batch|
      puts "   --> Running #{batch.first.class.name} batch of #{batch.count}"

      activities = batch.collect { |i| {
          activity_id: i.id,
          character_id: i.character_id,
          user_id: i.user_id,
          created_at: i.created_at,
          activity_type: 'Image',
          activity_method: 'create'
      } }

      Activity.create activities
    end

    Forum::Discussion.select(:id, :user_id, :created_at).find_in_batches do |batch|
      puts "   --> Running #{batch.first.class.name} batch of #{batch.count}"

      activities = batch.collect { |i| {
          activity_id: i.id,
          user_id: i.user_id,
          created_at: i.created_at,
          activity_type: 'Forum::Discussion',
          activity_method: 'create'
      } }

      Activity.create activities
    end


    Media::Comment.select(:id, :user_id, :created_at).find_in_batches do |batch|
      puts "   --> Running #{batch.first.class.name} batch of #{batch.count}"

      activities = batch.collect { |i| {
          activity_id: i.id,
          user_id: i.user_id,
          created_at: i.created_at,
          activity_type: 'Media::Comment',
          activity_method: 'create'
      } }

      Activity.create activities
    end
  end

  def down
    Activity.delete_all
  end
end
