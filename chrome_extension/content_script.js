chrome.runtime.onMessage.addListener(function(msg, sender, sendResponse) {
    if (msg.text && (msg.text == 'posting_start')) {
      $("<div id='quiche_posting_animation'>Quiche is baking...</div>").hide().prependTo('body').slideDown();
    }
    else if (msg.text && (msg.text == 'posting_end')) {
      $('#quiche_posting_animation').text('Quiche has baked!')
    }
    else if (msg.text && (msg.text == 'posting_error')) {
      $('#quiche_posting_animation').text('Quiche error')
    }
    else {
      $('#quiche_posting_animation').text(msg.text)
    }
});
