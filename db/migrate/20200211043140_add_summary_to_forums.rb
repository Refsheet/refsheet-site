class AddSummaryToForums < ActiveRecord::Migration[6.0]
  class ::Forum < ActiveRecord::Base
  end

  def up
    add_column :forums, :summary, :text
    Forum.update_all('summary = description')
  end

  def down
    remove_column :forums, :summary
  end
end
