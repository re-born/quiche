class ChangeDatatypeOfFirstImageUrlInItems < ActiveRecord::Migration
  def up
    change_column :items, :first_image_url, :text, :limit => 1000
  end
  def down
    # This might cause trouble if you have strings longer
    # than 255 characters.
    change_column :items, :first_image_url, :string
  end
end
