// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(window).load(function() {
  open_modal('.read_more')
  open_modal('.comment')
  $('.read_button').bind("ajax:success", function(data, response, xhr){
    $item = $('#item_' + response.data.item_id)
    if (response.status == 'read') {
      $("<span class='user_icon' id='user_icon_" + response.data.user_id + "'><img src='" + response.image_url + "'></span>").appendTo($item.find('.reader_label').parent()).hide().fadeIn()
      $item.find('.read_button').find('i').addClass('already_read')
    } else if (response.status == 'unread') {
      $item.find('#user_icon_' + response.data.user_id).fadeOut(500, function() {
        this.remove()
        $item.find('.read_button').find('i').removeClass('already_read')
      })
    }
  })
  $('.tags').tagsInput({
    'width':'auto',
    'height':'23px',
    'defaultText':'add Tag',
    'onAddTag': onAddTag,
    'onRemoveTag': onRemoveTag,
    'removeWithBackspace' : false,
  });
})

function initSuggest(list) {
  new Suggest.Local(
    'search_text',    // 入力のエレメントID
    'suggest', // 補完候補を表示するエリアのID
    list,      // 補完候補の検索対象となる配列
    {dispMax: 10, interval: 1000}); // オプション
}
function onAddTag(tag) {
  $(this).closest('form').submit();
}
function onRemoveTag(tag) {
  $(this).closest('form').submit();
}

function open_modal(button){
  $(button).click(function() {
    event.preventDefault()
    $(this).parent().parent().children( button + '_modal' ).modal()
  })
}
