class AddUrlToItems < ActiveRecord::Migration
  def change
    add_column :items, :url, :text
  end
end
