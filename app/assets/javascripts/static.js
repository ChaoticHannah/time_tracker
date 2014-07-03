$(document).ready(function() {
  $('.table').find('tr.success').hide();
  $('.hide-resolved').click(function(){
    var _this = this;
    if ($(this).text() == 'Hide resolved issues') {
      $('.table').find('tr.success').fadeOut('slow');
      $(_this).text('Show resolved issues');
    }
    else {
      $('.table').find('tr.success').fadeIn('slow');
      $(_this).text('Hide resolved issues');
    }
  });
  $('.user-assign').click(function() {
    $(this).removeClass('user-assign').addClass('user-assigned').replaceWith('assigned');
  });
})
