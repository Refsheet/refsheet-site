class AddDefaultsToSlotCounters < ActiveRecord::Migration[5.0]
  class ::Campaign < ActiveRecord::Base
    self.table_name = 'advertisement_campaigns'
  end

  def up
    change_column :advertisement_campaigns, :slots_requested, :integer, default: 0
    change_column :advertisement_campaigns, :slots_filled, :integer, default: 0
    change_column :advertisement_campaigns, :total_impressions, :integer, default: 0
    change_column :advertisement_campaigns, :total_clicks, :integer, default: 0
    change_column :advertisement_campaigns, :recurring, :boolean, default: false

    [:slots_requested, :slots_filled, :total_impressions, :total_clicks].each do |default|
      Campaign.where(default => nil).update_all(default => 0)
    end

    Campaign.where(recurring: nil).update_all(recurring: false)
  end

  def down; end
end
