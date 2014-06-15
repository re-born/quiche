module Notification
  extend ActiveSupport::Concern

  def tweet(tweet_content)
    require 'twitter'
    client = Twitter::REST::Client.new do |config|
      config.consumer_key       = ENV['consumer_key']
      config.consumer_secret    = ENV['consumer_secret']
      config.access_token        = ENV['oauth_token']
      config.access_token_secret = ENV['oauth_token_secret']
    end
    tweet_content = (tweet_content.length > 140) ? tweet_content[0..139].to_s : tweet_content
    begin
      client.update(tweet_content)
    rescue Exception => e
      p e
    end
  end

  def slack_notify(message)
    require 'slack-notify'
    client = SlackNotify::Client.new('reborn', ENV['slack_incoming_token'], {username: 'Quiche bot'} )
    client.notify(message , '#oven')
  end
end
