class AddTypeToItems < ActiveRecord::Migration
  def change
    add_column :items, :quiche_type, :integer
  end
end
