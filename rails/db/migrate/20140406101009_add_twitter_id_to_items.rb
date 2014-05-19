class AddTwitterIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :twitter_id, :string
  end
end
