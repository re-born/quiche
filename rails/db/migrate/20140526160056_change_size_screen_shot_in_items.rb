class ChangeSizeScreenShotInItems < ActiveRecord::Migration
  def change
    change_column :items, :screen_shot, :binary, :limit => 16777215
  end
end
