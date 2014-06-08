class API < Grape::API
  prefix 'api'
  version 'v0.1', using: :path
  format :json

  resource :tag do
    get do
      ActsAsTaggableOn::Tag.all
    end
  end
end
