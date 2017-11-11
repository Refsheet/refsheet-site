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
      if self.name =~ /\Aadvertisement\.(.*)\z/
        ad = Advertisement::Campaign.find_by guid: self.properties[:advertisement_id]
        return unless ad

        case $1
          when 'click'
            ad.record_click
          when 'impression'
            ad.record_impression
        end
      end
    end
  end
end
