module ItemsHelper
  def add_tag(str, item)
    item.tag_list.add(str)
    item.save
    item.reload
  end
end
