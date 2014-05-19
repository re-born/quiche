class AddColumnsToItems < ActiveRecord::Migration
  def change
    add_column :items, :screen_shot, :binary
  end
end
