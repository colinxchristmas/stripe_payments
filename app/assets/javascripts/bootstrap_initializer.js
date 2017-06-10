$(document).on('turbolinks:load', function() {
  $('.has-tooltip').tooltip();
  $('.has-popover').popover({
    trigger: 'hover'
  });
});
