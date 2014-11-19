class UsersController < ApplicationController
  include ApplicationHelper
  include ItemsHelper

  def show
    if params[:twitter_id]
      @user = User.where(twitter_id: "#{params[:twitter_id]}").first
      user_id = @user.id
      reader_ids = []
      reader_ids.push @user.id
    end

    @query = params[:query]
    @current_page = {}
    @items = {}
    @items["length"] = {}

    ["main", "gouter"].each_with_index do |quiche_type, i|
      @current_page[quiche_type] = params[quiche_type.to_sym] || 1
      @items['length'][quiche_type], @items[quiche_type] = search(
                                    quiche_type: i,
                                    member: current_user.present?,
                                    page: params[quiche_type.to_sym],
                                    text: params[:query],
                                    user_id: user_id,
                                    reader_ids: reader_ids,
                                    reader_and: false
                                    )
    end
  end
end
