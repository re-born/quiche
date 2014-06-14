require "fileutils"

CONTENT_FILE_NAME = "script/data_content.csv"
TAG_FILE_NAME = "script/data_tag.csv"

TAGS_TO_BE_REMOVED = [/<div>/, /<\/div>/, /\n/, /\t/, /<p>/, /<\/p>/].freeze

def write_content_and_tag item
	File.open(CONTENT_FILE_NAME, "a") { |file|
        content = item.content
        TAGS_TO_BE_REMOVED.each { |pattern| content.gsub!(pattern, '') }
	    content.gsub!(' ', '')
	    file.puts content
	}
	File.open(TAG_FILE_NAME, "a") { |file|
        tags = item.tag_list
        file.puts CSV.generate_line tags
	}
end

FileUtils.rm(CONTENT_FILE_NAME)
FileUtils.rm(TAG_FILE_NAME)

items = Item.where(quiche_type: 0)
for item in items
    write_content_and_tag item
end
