class SessionsController < ApplicationController
  def index

  end
  def create
    auth = request.env['omniauth.auth']
    if reborns_twitter_id_array.include?(auth.info.nickname)
      user = User.find_by({twitter_id: auth.info.nickname}) || User.create_with_omniauth(auth)
      session[:user_id] = user.id
      redirect_to root_url, notice: 'Signed in!'
    else
      redirect_to root_url, notice: 'You are not members.'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Signed out!'
  end

  private

    def reborns_twitter_id_array
      require 'twitter'
      client = Twitter::REST::Client.new do |config|
        config.consumer_key       = ENV['consumer_key']
        config.consumer_secret    = ENV['consumer_secret']
        config.access_token        = ENV['oauth_token']
        config.access_token_secret = ENV['oauth_token_secret']
      end
      client.list_members('daipanchi','reborns').map(&:screen_name)
    end
end
