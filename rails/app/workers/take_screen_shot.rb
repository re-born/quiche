require 'imgkit'

class TakeScreenShot
  @queue = :take_screen_shot

  def self.perform(item_id, url)
    sleep 5
    logger = Logger.new(File.join(Rails.root, 'log', 'resque.log'))
    logger.info "Hello #{item_id}"
    screen_shot_binary = take_screen_shot(url)
    @item = Item.find(item_id)
    @item.update!(screen_shot: screen_shot_binary)
    logger.info "finish #{item_id}"
  end
end

def take_screen_shot(url)
  IMGKit.new(url, width: 144).to_img(:jpg)
end
