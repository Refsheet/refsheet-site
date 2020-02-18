class AddSummaryToForums < ActiveRecord::Migration[6.0]
  class ::MForum < ActiveRecord::Base
    self.table_name = :forums
  end

  def up
    add_column :forums, :summary, :text
    ::MForum.update_all('summary = description')
  end

  def down
    remove_column :forums, :summary
  end
end
