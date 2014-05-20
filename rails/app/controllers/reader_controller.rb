class ReaderController < ApplicationController
  before_action :set_item

  def toggle_reader
    if @item.readers.pluck(:user_id).include?(current_user.id)
      @reader = @item.readers.find_by({user_id: current_user.id}).destroy
      status = 'unread'
    else
      @reader = Reader.create({user_id: current_user.id, item: @item})
      status = 'read'
    end
    render json: { status: status, data: @reader, image_url: @reader.user.image_url }
  end

  private
    def set_item
      @item = Item.find(params[:item_id])
    end
end
