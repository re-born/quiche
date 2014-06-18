class CommentsController < ApplicationController
  def create
    current_user.comments.create(
      item_id: params[:comment][:item_id].to_i,
      content: params[:comment][:content]
      )
    redirect_to '/'
  end
end
