# -*- encoding: utf-8 -*-

require 'spec_helper'
require 'capybara'

describe ItemsController do
  let(:item) { FactoryGirl.create(:item) }

  # TODO auto-generated
  describe '#index' do
    it 'works' do
      result = items_controller.index
      expect(result).not_to item
    end
  end

  # TODO auto-generated
  describe '#show' do
    it 'works' do
      items_controller = ItemsController.new
      result = items_controller.show
      expect(result).not_to be_nil
    end
  end

  # TODO auto-generated
  describe '#new' do
    it 'works' do
      items_controller = ItemsController.new
      result = items_controller.new
      expect(result).not_to be_nil
    end
  end

  # TODO auto-generated
  describe '#edit' do
    it 'works' do
      items_controller = ItemsController.new
      result = items_controller.edit
      expect(result).not_to be_nil
    end
  end

  # TODO auto-generated
  describe '#create' do
    before do
      @params = {
        url: 'http://engineer.typemag.jp/article/spacexart_teamlab',
        user: {
          quiche_twitter_id: 'daipanchi'
        },
        quiche_type: 'main'
      }
    end

    let!(:user) { FactoryGirl.create(:user) }

    it 'works' do
      expect { xhr :post, 'create', @params }.to change(Item, :count).by(1)
    end
  end

  # TODO auto-generated
  describe '#update' do
    it 'works' do
      items_controller = ItemsController.new
      result = items_controller.update
      expect(result).not_to be_nil
    end
  end

  # TODO auto-generated
  describe '#destroy' do
    it 'works' do
      items_controller = ItemsController.new
      result = items_controller.destroy
      expect(result).not_to be_nil
    end
  end

  # TODO auto-generated
  describe '#get_image' do
    it 'works' do
      items_controller = ItemsController.new
      result = items_controller.get_image
      expect(result).not_to be_nil
    end
  end

end
