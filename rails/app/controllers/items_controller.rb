class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper
  def index
    user = User.where("last_name = ? or twitter_id = ?", params[:query], params[:query])
    @items = {}
    @current_page = {}
    @query = {}
    ['main', 'gouter'].each_with_index do |quiche_type, i|
      result = Item.search do
        if (user.blank?)
          fulltext params[:query]
        else
          with(:user_id, user.first.id)
        end
        with(:quiche_type, i)
        order_by :created_at, :desc
        paginate({ page: params[quiche_type.to_sym] || 1, per_page: 30 })
      end
      @items[quiche_type] = result.results
      @current_page[quiche_type] = params[quiche_type.to_sym] || 1
      @query[quiche_type] = params[:query]
    end
  end

  def show
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    require 'open-uri'
    uri = URI params[:url]
    source = open(uri).read
    obj = Readability::Document.new(source, encoding: source.encoding.to_s)

    title = obj.title
    content_html = obj.content.encode('UTF-8')
    images = obj.images

    # TODO Avoid using direct link
    unless images.empty?
      if  ( (images[0] =~ /^\//) == 0) # relative path
        images[0] = 'http://' + uri.host + images[0]
      elsif ( (images[0] =~ /^http/) != 0) # filename only
        images[0] = 'http://' + uri.host + uri.path + images[0]
      end
    else
      screen_shot_binary = IMGKit.new(params[:url], width: 144).to_img(:jpg)
    end

    twitter_id = params[:user][:quiche_twitter_id]
    image_url = params[:user][:quiche_twitter_image_url]

    if ( ( user = User.find_by(twitter_id: twitter_id) ) == nil )
      message = 'Create user in "Oven" before Baking!' # chrome extention で表示
    elsif ( item = Item.find_by(title: title) ) # 既に読まれていた場合
      if(item.user == user)
        message = 'You have already read!'
      elsif Reader.new({user: user, item: item}).save # user を reader に追加
        message = 'Your Quiche has also baked!'
      else
        message = 'You have already read!'
      end
    else
      @item = Item.new({
        title: title,
        url: params[:url],
        content: content_html,
        quiche_type: Item::QUICHE_TYPE[params['quiche_type'].to_sym],
        first_image_url: images[0],
        screen_shot: screen_shot_binary,
        user_id: User.find_by(twitter_id: twitter_id).id
        })
      if @item.save
        message = 'success'
        unless params[:quiche_type] == 'gouter'
          bitly = Bitly.new(ENV['bitly_legacy_login'], ENV['bitly_legacy_api_key'])
          tweet('['+title.truncate(108) + '] が焼けたよ ' + bitly.shorten(params[:url]).short_url)
        end
      else
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
    respond_to do |format|
      format.json {
        render json: {
          action: 'add',
          result: message,
        }
      }
    end
  end

  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.js { @success = true }
      else
        format.html { render action: 'edit' }
        format.js { @sucess = false, @notice = @item.errors }
      end
    end
  end

  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to '/' }
      format.json { head :no_content }
    end
  end

  def get_image
    send_data(Item.find(params[:id]).screen_shot, filename: "#{Item.find(params[:id])}.jpg", :disposition => 'inline' , type: 'image/jpeg')
  end

  private
    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:title, :first_image_url, :user_id, :name, :content, :deleted_at, :tag_list)
    end

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
end
