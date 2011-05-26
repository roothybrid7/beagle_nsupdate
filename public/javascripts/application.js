$(function() {
  $('*')
    .ajaxStart(function() {$('#progress').html('Progress...')})
    .ajaxComplete(function() {$('#progress').html('')});
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
