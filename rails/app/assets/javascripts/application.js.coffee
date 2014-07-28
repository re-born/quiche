#= require jquery
#= require jquery.lazyload.min
#= require jquery.modal.min
#= require tagsinput
#= require jquery.ajax.deferred

$(window).load ->
  $('.tag_div').fadeIn(1000)
  open_modal('.read_more')
  open_modal('.comment')
  $('.read_button').bind "ajax:success", (data, response, xhr) ->
    $item = $('#item_' + response.data.item_id)
    if (response.status == 'read')
      $("<span class='user_icon' id='user_icon_" + response.data.user_id + "'><img src='" + response.image_url + "'></span>").appendTo($item.find('.reader_label').parent()).hide().fadeIn()
      $item.find('.read_button i').addClass('already_read')
      return
    else if (response.status == 'unread')
      $item.find('#user_icon_' + response.data.user_id).fadeOut 500, ->
        this.remove()
        $item.find('.read_button i').removeClass('already_read')
        return
      return


  $('.tags').tagsInput
    'width':'auto',
    'height':'23px',
    'defaultText':'add Tag',
    'interactive':true,
    'onAddTag': onAddTag,
    'onRemoveTag': onRemoveTag,
    'removeWithBackspace' : false,
  initSuggest()
  add_link_to_tag()
  return

add_link_to_tag = () ->
  $('.tag').on('click', ->
    tag_name = $(this).children('span').text().replace(/\s+/g, '')
    location.href = location.origin + '/items?query=' + tag_name
  )

$ ->
  $.each ['.main_quiches', '.gouter_quiches'], (i, val) ->
    $(val+' img.lazy').lazyload
      container: $(val),
      effect: 'fadeIn'
    return
  return

initSuggest = () ->
  $.getJSON('/api/v0.1/tag.json').next (tag_json) ->  # -- (1)
    tags = o.tag_json for o in tag_json
    $.getJSON('/api/v0.1/users.json').next (twitter_ids) ->  # -- (2)
      tags.concat(twitter_ids);
  .next (suggest_array) ->  # -- (3)
    new Suggest.Local(
      'search_text',    # 入力のエレメントID
      'suggest', # 補完候補を表示するエリアのID
      suggest_array,      # 補完候補の検索対象となる配列
      {dispMax: 10, interval: 1000} # オプション
    )
  .error (status) -> # -- (4)
    console.log 'error', status


onAddTag = (tag) ->
  $(this).closest('form').submit();

onRemoveTag = (tag) ->
  $(this).closest('form').submit();

open_modal = (button) ->
  $(button).click () ->
    event.preventDefault()
    $(this).parent().parent().children( button + '_modal' ).modal()


