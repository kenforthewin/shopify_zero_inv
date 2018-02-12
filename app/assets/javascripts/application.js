// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery/dist/jquery
//= require popper.js/dist/umd/popper
//= require bootstrap/dist/js/bootstrap
//= require d3/build/d3
//= require datatables/media/js/jquery.dataTables
//= require_tree .

$(document).on('turbolinks:load', function() {
  table = $('#products-table').DataTable()
  $('input[name="check-all"]').change(function() {
    table.$('input').prop("checked", $('input[name="check-all"]').prop('checked'))
  })
  $('#update-products').click(function() {
    $('#update-products').prop('disabled', 'disabled')
    $.get('/products/sync', function(data) {
      location.reload()
    })
  })
  $('#submit-zero-remove').click(function() {
    $('#submit-zero-remove').prop('disabled', 'disabled')
    ids = []
    $.each(table.$('input:checked'), function(index, el) {
      ids.push($(el).data('name'))
    })
    if(!ids.length) {
      $('#submit-zero-remove').prop('disabled', false)
      $('#finish-message').text("You didn't select any products. Try again.")
    } else {
      $('#loading-message').text('Working, please stand by...')
      $.post('/products/destroy_zero', { products: ids }, function(data){
        $('#loading-message').text('Done.')
        $('#finish-message').text(data.response_text)
      })
    }
  })
  ShopifyApp.ready(function() {
    ShopifyApp.Bar.loadingOff();
  });
})