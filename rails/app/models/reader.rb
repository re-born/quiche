class Reader < ActiveRecord::Base
  require 'lib'
  include Notification

  validates :user, uniqueness: {scope: :item}
  belongs_to :user
  belongs_to :item, touch: true

  after_create :notify_new_reader

  private

  def notify_new_reader
    slack_notify("@#{self.user.twitter_id} も 『#{self.item.title}』 を焼いたよ [##{self.item.id}](http://q.l0o0l.co/#item_#{self.item.id})", '#oven_gouter')
  end
end
