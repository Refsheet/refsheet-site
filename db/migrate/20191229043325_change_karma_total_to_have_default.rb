class ChangeKarmaTotalToHaveDefault < ActiveRecord::Migration[5.2]
  class ::Discussion < ActiveRecord::Base
    self.table_name = 'forum_threads'
  end

  def change
    ::Discussion.where(karma_total: nil).update_all(karma_total: 0)
    change_column :forum_threads, :karma_total, :integer, null: false, default: 0
  end
end
