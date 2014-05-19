class Item < ActiveRecord::Base
  belongs_to :user
  validates :title, uniqueness: true
  default_scope -> { order('created_at DESC') }

  has_many :readers
  has_many :comments

  searchable do
    text :title
    text :content
    time :created_at
    integer :user_id
  end

end
