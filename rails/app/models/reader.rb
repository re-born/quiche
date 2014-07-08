class Reader < ActiveRecord::Base
  validates :user, uniqueness: {scope: :item}
  belongs_to :user
  belongs_to :item, touch: true
end
