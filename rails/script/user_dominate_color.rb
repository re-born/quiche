require 'RMagick'
require 'kmeans-clustering'


Rails.logger = ActiveRecord::Base.logger = Logger.new(File.join(Rails.root, "log", "user_dominate_color.log"))
Rails.logger.debug "Listening..."

results = []

users = User.all
users.each do |user|
path = user.image_url
img = Magick::ImageList.new(path).first

# specify required operations
KMeansClustering::calcSum = lambda do |elements|
  sum = [0, 0, 0]
  elements.each do |element|
    sum[0] += element[0]
    sum[1] += element[1]
    sum[2] += element[2]
  end
  sum
end

KMeansClustering::calcAverage = lambda do |sum, nb_elements|
  average = [0, 0, 0]
  average[0] = sum[0] / nb_elements.to_f
  average[1] = sum[1] / nb_elements.to_f
  average[2] = sum[2] / nb_elements.to_f
  Rails.logger.debug average.to_s
  average
end

KMeansClustering::calcDistanceSquared = lambda do |element_a, element_b|
  d0 = element_b[0] - element_a[0]
  d1 = element_b[1] - element_a[1]
  d2 = element_b[2] - element_a[2]
  (d0 * d0) + (d1 * d1) + (d2 * d2)
end

# generate pixel elements
elements = []
for y in 0...img.rows
  for x in 0...img.columns
    src = img.pixel_color(x, y) # 元画像のピクセルを取得
    rgb = [src.red/257, src.green/257, src.blue/257]
    # Rails.logger.debug rgb.to_s
    elements << rgb
  end
end

# pick 3 random elements to act as initial centers
centers = elements.sample(3)

# apply 10 iterations of the k-means clustering algorithm
# and split each iteration across 3 different processors
new_centers = KMeansClustering::run(centers, elements, 10, 1)
d_colors = []
for i in 0...new_centers.length
  d_colors[i] = [new_centers[i][0].to_i, new_centers[i][1].to_i, new_centers[i][2].to_i]
end

Rails.logger.debug d_colors.to_s
Rails.logger.debug user.twitter_id

results << user.twitter_id + " : " + d_colors.to_s
end

Rails.logger.debug "Result is"
for i in 0...results.length
  Rails.logger.debug results[i].to_s
end
Rails.logger.debug "Finished."


