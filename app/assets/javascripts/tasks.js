$(document).ready(function(){
  $('#user-assign').hide();
  $('#user-assign-flag').click(function(e) {
    if ($(this).prop('checked')) {
      $('#user-assign').show();
    }
    else {
      $('#user-assign').hide();
      $('#user-assign').hide();
      $("#task_user option:first").attr("selected", true);
    }
  });
}).load()
