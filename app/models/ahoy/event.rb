# == Schema Information
#
# Table name: ahoy_events
#
#  id         :integer          not null, primary key
#  visit_id   :integer
#  user_id    :integer
#  name       :string
#  properties :jsonb
#  time       :datetime
#
# Indexes
#
#  index_ahoy_events_on_name_and_time      (name,time)
#  index_ahoy_events_on_user_id_and_name   (user_id,name)
#  index_ahoy_events_on_visit_id_and_name  (visit_id,name)
#

module Ahoy
  class Event < ActiveRecord::Base
    include Ahoy::Properties

    self.table_name = "ahoy_events"

    belongs_to :visit
    belongs_to :user, optional: true


    #== Tell Adverts to Cycle

    after_commit do
      Rails.logger.tagged 'Event after_commit' do
        Rails.logger.info "Processing post-commit hook for #{self.name}: #{self.properties.inspect}"

        if self.name =~ /\Aadvertisement\.(.*)\z/
          Rails.logger.info "Processing ad event tracking for #{$1} action on #{self.properties['advertisement_id']}"

          if (ad = Advertisement::Campaign.find_by guid: self.properties['advertisement_id'])
            Rails.logger.info "Using ad: #{ad.title}"

            case $1
              when 'click'
                ad.record_click
              when 'impression'
                ad.record_impression self.properties['current_slot_id']
            end
          end
        end
      end
    end
  end
end
