class AddCounterCacheToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :comments_count, :integer
    add_column :images, :favorites_count, :integer

    reversible do |dir|
      dir.up { data }
    end
  end

  def data
    execute <<-SQL.squish
        UPDATE images SET comments_count = (SELECT count(1) FROM media_comments WHERE media_comments.media_id = images.id);
        UPDATE images SET favorites_count = (SELECT count(1) FROM media_favorites WHERE media_favorites.media_id = images.id);
    SQL
  end
end
