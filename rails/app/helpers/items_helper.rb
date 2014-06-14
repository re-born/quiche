module ItemsHelper

  def add_tag(str, item)
    item.tag_list.add('weekly_report')
    item.save
    item.reload
  end
end