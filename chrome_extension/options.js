document.getElementById('save').onclick = function() {
  var last_name = document.getElementById('last_name').value
  localStorage['last_name'] = last_name
}

document.body.onload = function() {
  document.getElementById('last_name').value = localStorage['last_name']
}