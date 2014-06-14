# -*- encoding: utf-8 -*-

require 'spec_helper'
require './models/user'

describe User do

  # TODO auto-generated
  describe '#create_with_omniauth' do
    it 'works' do
      auth = double('auth')
      result = User.create_with_omniauth(auth)
      expect(result).not_to be_nil
    end
  end

end
