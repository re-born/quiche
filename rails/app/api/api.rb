class API < Grape::API
  prefix 'api'
  version 'v0.1', using: :path
  format :json

  resource :tag do
    get do
      ActsAsTaggableOn::Tag.all
    end
  end
  resource :users do
    get do
      User.all.pluck(:twitter_id)
    end
  end
end
