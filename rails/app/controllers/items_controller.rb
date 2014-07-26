class ItemsController < ApplicationController
  include ApplicationHelper
  include ItemsHelper

  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :check_logged_in_user, only: [:update]

  ALLOWED_TAGS = ((1..6).map { |i| "h#{i}" } + %w(div p img a)).freeze

  def index
    Rails.logger.level = Logger::ERROR
    @query = params[:query]
    @current_page = {}
    @items = {}
    @items['length'] = {}
    user = User.where("last_name = ? or twitter_id = ?", params[:query], params[:query])
    unless user.blank?
      user_id = user.first.id
      params[:query] = nil
    end

    ['main', 'gouter'].each_with_index do |quiche_type, i|
      @current_page[quiche_type] = params[quiche_type.to_sym] || 1
      @items['length'][quiche_type], @items[quiche_type] = search(quiche_type: i,
                                    member: current_user.present?,
                                    page: params[quiche_type.to_sym],
                                    text: params[:query],
                                    user_id: user_id)
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
    obj = Readability::Document.new(source,
                                    tags: ALLOWED_TAGS,
                                    attributes: %w(src href),
                                    encoding: source.encoding.to_s)

    title = obj.title
    content_html = obj.content.encode('UTF-8')
    images = obj.images
    twitter_id = params[:user][:quiche_twitter_id]

    if ( ( user = User.find_by(twitter_id: twitter_id) ) == nil )
      message = 'Create user in "Oven" before Baking!'
    elsif ( item = Item.find_by(title: title) )
      message = already_read_message(item, user)
    else
      if images.empty?
        screen_shot_binary = take_screen_shot(params[:url])
      else
        images[0] = absolute_image_path(images[0], uri)
      end
      @item = Item.new({
        title: title,
        url: params[:url],
        content: content_html,
        quiche_type: Item::QUICHE_TYPE[params['quiche_type'].to_sym],
        first_image_url: images[0],
        screen_shot: screen_shot_binary,
        user_id: user.id,
        private: (params[:url] =~ /qiita.com\/.+\/private/) != nil
        })
      if @item.save
        message = 'success'
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

    def check_logged_in_user
      if current_user.nil?
        redirect_to root_path
      end
    end
end
