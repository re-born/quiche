
CONTENT_FILE_NAME = 'script/data_content.csv'
TAG_FILE_NAME = 'script/data_tag.csv'

TAGS_TO_BE_REMOVED = [/<div>/, /<\/div>/, /\n/, /\t/, /<p>/, /<\/p>/].freeze

def write_content_and_tag item
  File.open(CONTENT_FILE_NAME, 'a') do |file|
    content = item.content
    TAGS_TO_BE_REMOVED.each { |pattern| content.gsub!(pattern, '') }
    ActionController::Base.helpers.sanitize(content, tags: %w(div p))
    content.gsub!(' ', '')
    content.gsub!('&#13', '')
    file.puts content
  end
  File.open(TAG_FILE_NAME, 'a') do |file|
    tags = item.tag_list
    file.puts CSV.generate_line tags
  end
end

if File.exist?(CONTENT_FILE_NAME)
  FileUtils.rm(CONTENT_FILE_NAME)
end
if File.exist?(TAG_FILE_NAME)
  FileUtils.rm(TAG_FILE_NAME)
end

items = Item.where(quiche_type: 0)
items.each do |item|
  write_content_and_tag item
end
