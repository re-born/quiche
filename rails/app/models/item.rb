class Item < ActiveRecord::Base
  belongs_to :user
  validates :title, uniqueness: true
  default_scope -> { order('created_at DESC') }

  has_many :readers
  has_many :comments

  QUICHE_TYPE = {
    main: 0,
    gouter: 1
  }

  acts_as_taggable # Alias for acts_as_taggable_on :tags
  searchable do
    text :title
    text :content
    text :tag_list
    time :created_at
    integer :user_id
    integer :quiche_type
    boolean :private
  end

end
