class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :last_name
      t.string :image_url
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
