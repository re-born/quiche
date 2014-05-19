class User < ActiveRecord::Base
  validates :twitter_id, uniqueness: true
  validates :twitter_id, presence: true
  validates :image_url, presence: true
  has_many :reader
  has_many :comments

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.last_name = auth['info']['name']
      user.image_url = auth['info']['image']
      user.twitter_id = auth['info']['nickname']
    end
  end
end
