class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.string :first_image_url
      t.references :user, index: true
      t.string :name
      t.text :content
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
