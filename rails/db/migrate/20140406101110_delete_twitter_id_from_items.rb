class DeleteTwitterIdFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :twitter_id, :string
  end
end
