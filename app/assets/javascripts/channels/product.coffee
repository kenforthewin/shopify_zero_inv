$(document).on 'turbolinks:load', ->
  $('#submit-zero-remove').prop 'disabled', false
  $('#update-products').prop 'disabled', false
  $('input[name="check-all"]').prop('checked', false)
  $('input[name="check-all"]').change ->
    table.$('input').prop 'checked', $('input[name="check-all"]').prop('checked')
    return
  $('#update-products').click ->
    $('#update-products').prop 'disabled', 'disabled'
    $.get '/products/sync', (data) ->
      return
    return
  $('#submit-zero-remove').click ->
    ids = []
    $.each table.$('input:checked'), (index, el) ->
      ids.push $(el).data('name')
      return
    $('#submit-zero-remove').prop 'disabled', 'disabled'
    if !ids.length
      $('#submit-zero-remove').prop 'disabled', false
      $('#finish-message').text 'You didn\'t select any products. Try again.'
    else
      message = 'Are you sure? This will permanently delete ' + ids.length + ' product(s).'
      if confirm(message)
        # $('#loading-message').text 'Working, please stand by...'
        $.post '/products/destroy_zero', { products: ids }, (data) ->
          # $('#loading-message').text 'Done.'
          # $('#finish-message').text data.response_text
          return
      else
        $('#submit-zero-remove').prop 'disabled', false

  if $('#loading-bar').length > 0
    App.product_channel = App.product_channel || App.cable.subscriptions.create "ProductChannel",
      connected: ->
        console.log 'connected'
        $.get('/products/sync')
      received: (data) ->
        console.log(data)
        if data.message == "products_loaded"
          init_table()
          $('#update-products').prop 'disabled', false
          $('input[name="check-all"]').prop('checked', false)
        else if data.message == "products_deleting"
          refresh_loader(data.count, data.total)
        else if data.message == "products_deleted"
          $('#finish-message').text "Complete."
          $('#submit-zero-remove').prop 'disabled', false
refresh_loader = (count, total) ->
  percent = count / total
  formatPercent = Math.ceil (percent * 100)
  percentString = formatPercent + "%"
  $('#loading-bar .progress-bar').css 'width', percentString
  $('#loading-bar .progress-bar span').text percentString
  $('#loading-bar').css 'display', 'block'
  text = count.toString() + " of " + total.toString() + " deleted."
  $('#finish-message').text text

init_table = ->
  this.table = this.table || $('#products-table').DataTable
    ajax: 
      url: '/products/get_products'
      dataSrc: ''
    columns: [
      { width: "10px" },
      { width: "40%" },
      null,
      null,
      null,
      { width: "10px" }
    ]
  this.table.ajax.reload()