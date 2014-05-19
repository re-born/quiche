Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['consumer_key'], ENV['consumer_secret'],
  { :secure_image_url => 'true'}
end