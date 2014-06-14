# -*- encoding: utf-8 -*-

require 'spec_helper'
require './controllers/sessions_controller'

describe SessionsController do

  # TODO auto-generated
  describe '#index' do
    it 'works' do
      sessions_controller = SessionsController.new
      result = sessions_controller.index
      expect(result).not_to be_nil
    end
  end

  # TODO auto-generated
  describe '#create' do
    it 'works' do
      sessions_controller = SessionsController.new
      result = sessions_controller.create
      expect(result).not_to be_nil
    end
  end

  # TODO auto-generated
  describe '#destroy' do
    it 'works' do
      sessions_controller = SessionsController.new
      result = sessions_controller.destroy
      expect(result).not_to be_nil
    end
  end

end
