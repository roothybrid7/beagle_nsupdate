$(function() {
  $('*')
    .ajaxStart(function() {$('#progress').html('通信中...')})
    .ajaxComplete(function() {$('#progress').html('')});

//  $('input[title]').each(function() {
//    if($(this).val() === '') {
//      $(this).val($(this).attr('title'));
//    }
//
//    $(this).focus(function() {
//      if($(this).val() === $(this).attr('title')) {
//        $(this).val('').addClass('focused');
//      }
//    });
//
//    $(this).blur(function() {
//      if($(this).val() === '') {
//        $(this).val($(this).attr('title')).removeClass('focused');
//      }
//    });
//  });
});

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();  // hidden a table record of remove candidation(tr.fields)
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}
