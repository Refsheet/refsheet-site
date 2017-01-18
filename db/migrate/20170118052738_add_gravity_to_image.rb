class AddGravityToImage < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :gravity, :string
  end
end
