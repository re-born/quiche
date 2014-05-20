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
  $('.comment_button').click(function() {
    event.preventDefault();
    $(this).parent().parent().children('.modal').modal()
  })
  $('.tags').tagsInput({
  	'width':'auto',
  	'height':'23px',
  	'defaultText':'+',
  });

  $('.tagsinput div input').keypress(function (e) {
    if (e.which == 13) {
      $(e.target).closest('form').submit();
      return false;
    }
  });
})

function initSuggest(list) {
  new Suggest.Local(
    'search_text',    // 入力のエレメントID
    'suggest', // 補完候補を表示するエリアのID
    list,      // 補完候補の検索対象となる配列
    {dispMax: 10, interval: 1000}); // オプション
}
