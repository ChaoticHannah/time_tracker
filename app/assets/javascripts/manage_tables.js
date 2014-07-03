$(document).ready(function() {
  var table_id;
  if (window.location.href.indexOf('users') > -1) {
    table_id = 'users-table'
  }
  if (window.location.href.indexOf('projects') > -1) {
    table_id = 'projects-table'
  }
  if (window.location.href.indexOf('tasks') > -1) {
    table_id = 'tasks-table'
  }
  $('.delete-from-table').click(function() {
    var table = document.getElementById(table_id);
    var _this = this;
    if($(table).find('tbody').children(':visible').length == 2) {
      $(table).fadeOut('slow');
    }
    else {
      $(_this).closest('tr').fadeOut('slow');
    }
  })
})
