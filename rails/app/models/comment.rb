class Comment < ActiveRecord::Base
  require 'lib'
  include Notification

  belongs_to :user
  belongs_to :item
  validates :content, presence: true
  default_scope -> { order('created_at DESC') }
  after_create :notify_new_comment

  private

  def notify_new_comment
    tweet "[#{item.title.truncate(50)}]にコメントが付いたよ: 「#{content.truncate(70)}」"
  end
end
