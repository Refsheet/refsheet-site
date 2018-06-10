namespace :freshdesk do
  desc 'Push unresolved feedback to freshdesk.'
  task :push => :environment do
    Feedback.where(freshdesk_id: nil).find_each do |feedback|
      puts "Sync #{feedback.id}"
      feedback.post_to_freshdesk
      puts "-> #{feedback.freshdesk_id}"
    end
  end
end
