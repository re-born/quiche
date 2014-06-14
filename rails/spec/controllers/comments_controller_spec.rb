# -*- encoding: utf-8 -*-

require 'spec_helper'
require './controllers/comments_controller'

describe CommentsController do

  # TODO auto-generated
  describe '#create' do
    it 'works' do
      comments_controller = CommentsController.new
      result = comments_controller.create
      expect(result).not_to be_nil
    end
  end

end
