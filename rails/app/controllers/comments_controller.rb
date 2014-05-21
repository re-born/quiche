class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(item_id: params[:comment][:item_id].to_i, content: params[:comment][:content])
    if @comment.save
      tweet('[' + @comment.item.title.truncate(50) + ']にコメントが付いたよ: 「' + @comment.content.truncate(70) + '」'  )
    else
      @comment_items = []
      # render 'static_pages/home'
    end
      redirect_to '/'
  end

  private
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

    def comment_params
      params.require(:comment).permit(:content,:item_id)
    end
end
