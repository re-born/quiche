module ApplicationHelper

  #TODO move to decorator
  def extract_url(url)
    url = URI(url)
    extracted_url = url.scheme + '://' + url.host + url.path
  end

  #TODO move to decorator
  def re_arrange(str)
    str.gsub('&#13;', '').gsub(/<div>/,'').gsub(/<\/div>/,'').gsub(/ ?/,'').gsub(/\n/,'').gsub(/\t/,'').gsub(/<p> <\/p>/,'').truncate(100)
  end
end
