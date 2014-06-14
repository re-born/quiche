# -*- encoding: utf-8 -*-

require 'spec_helper'
require './helpers/application_helper'

describe ApplicationHelper do

  # TODO auto-generated
  describe '#extract_url' do
    it 'works' do
      application_helper = ApplicationHelper.new
      url = double('url')
      result = application_helper.extract_url(url)
      expect(result).not_to be_nil
    end
  end

  # TODO auto-generated
  describe '#re_arrange' do
    it 'works' do
      application_helper = ApplicationHelper.new
      str = double('str')
      result = application_helper.re_arrange(str)
      expect(result).not_to be_nil
    end
  end

end
