module ItemsHelper
  PER_PAGE = 30

  def absolute_image_path(image_url, uri)
    if  ( (image_url =~ /^\//) == 0 ) # relative path
      image_url = 'http://' + uri.host + image_url
    elsif ( (image_url =~ /^http/) != 0 ) # filename only
      image_url = 'http://' + uri.host + uri.path + image_url
    else
      image_url
    end
  end

  def take_screen_shot(url)
    IMGKit.new(url, width: 144).to_img(:jpg)
  end

  def already_read_message(item, user)
    if (item.user == user || item.readers.include?(user))
      'You have already read!'
    else
      Reader.create(user: user, item: item)
      'Your Quiche has also baked!'
    end
  end

  def search(query)
    quiche_type = query[:quiche_type]
    member_flag = query[:menber]
    page = query[:page] || 1
    text = query[:text]
    user_id = query[:user_id]
    reader_ids = query[:reader_ids]
    reader_and_flag = query[:reader_and]
    tag_ids = query[:tag_ids]
    tag_and_flag = query[:tag_and]
    from_date = query[:from]
    until_date = query[:until]

    result = Item.search do
      order_by :created_at, :desc
      with(:quiche_type, quiche_type)

      unless member_flag.nil?
        if member_flag
          without(:private, true)
        end
      end

      paginate(page: page, per_page: PER_PAGE)

      unless text.nil?
        fulltext text
      end

      unless user_id.nil?
        with(:user_id, user_id)
      end

      unless reader_and_flag.nil?
        if reader_and_flag
          reader_ids.each do |id|
            with(:readers, id)
          end
        else
          any_of do
            with(:readers, reader_ids)
          end
        end
      end

      unless tag_and_flag.nil?
        if tag_and_flag
          tag_ids.each do |id|
            with(:tags, id)
          end
        else
          any_of do
            with(:tags, tag_ids)
          end
        end
      end

      unless from_date.nil?
        with(:created_at).greater_than(from_date)
      end

      unless until_date.nil?
        with(:created_at).less_than(until_date)
      end
    end

    result.results
  end
end
