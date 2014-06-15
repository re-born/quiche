class Item < ActiveRecord::Base
  require 'lib'
  include Notification
  include ItemsHelper

  after_create :notify_new_item

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
    integer :readers, multiple: true do |item|
      item.readers.pluck(:user_id)
    end
    integer :tags, multiple: true do |item|
      item.tags.pluck(:id)
    end
    integer :quiche_type
    boolean :private
  end

  def add_tag(str)
    self.tag_list.add(str)
    self.save
    self.reload
  end

  private

  def notify_new_item
    unless (self.quiche_type == 1) || self.private
      bitly = Bitly.new(ENV['bitly_legacy_login'], ENV['bitly_legacy_api_key'])
      tweet("[ #{self.title.truncate(108)}] が焼けたよ #{bitly.shorten(self.url).short_url}" )
    end
    if self.private
      slack_notify("A new weekly report has baked! #{self.url}")
      add_tag('weekly_report')
    end
  end
end
