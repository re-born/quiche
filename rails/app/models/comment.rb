class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
  validates :content, presence: true
  default_scope -> { order('created_at DESC') }
end
