class Comment < ActiveRecord::Base
  require 'lib'
  include Notification

  belongs_to :user
  belongs_to :item, touch: true
  validates :content, presence: true
  default_scope -> { order('created_at DESC') }
  after_create :notify_new_comment

  private

  def notify_new_comment
    slack_notify("[#{item.title}]にコメントが付いたよ: 「#{content}」", '#oven')
  end
end
