class AddPrivateFlagToItem < ActiveRecord::Migration
  def change
    add_column :items, :private, :boolean
  end
end
