class Lodestone::SyncCharacterJob < ApplicationJob
  queue_as :default

  MAX_REQ_PER_SECOND = 20

  def perform
    scope = Lodestone::Character.where('remote_updated_at < ?', 1.day.ago)
    puts "Updating #{scope.count} records."

    rate = 1 / (MAX_REQ_PER_SECOND/2)
    last = Time.now

    scope.find_each do |record|
      Lodestone::ImportCharacterJob.perform_now(lodestone_character_id: record.id)
      if (elapsed = Time.now - last) > rate
        sleep(rate - elapsed)
      end
      last = Time.now
    end

    puts "DONE"
  end
end
