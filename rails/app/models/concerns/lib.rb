module Notification
  extend ActiveSupport::Concern

  def tweet(tweet_content)
    require 'twitter'
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['consumer_key']
      config.consumer_secret     = ENV['consumer_secret']
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

  def slack_notify(message, room)
    require 'slack-notifier'
    notifier = Slack::Notifier.new('reborn',
                                   ENV['slack_incoming_token'],
                                   channel: room,
                                   username: 'Quiche bot',
                                   icon_url: 'https://pbs.twimg.com/profile_images/465866699145625600/q49lf5U5.png')
    notifier.ping message, unfurl_links: true
  end
end
