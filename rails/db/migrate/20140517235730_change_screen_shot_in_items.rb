class ChangeScreenShotInItems < ActiveRecord::Migration
  def change
    change_column :items, :screen_shot, :binary, :limit => 900.kilobyte
  end
end
