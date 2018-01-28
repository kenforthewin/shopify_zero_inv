# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
render_orders_price_dist = (data) ->
  margin = {top: 10, right: 30, bottom: 30, left: 40}
  width = 960 - margin.left - margin.right
  height = 500 - margin.top - margin.bottom

  # parseDate = d3.timeParse("%d-%m-%Y")

  x = d3.scaleLinear().rangeRound([0, width]).domain([0, 1.05 * d3.max(data, (d) -> d.parsed_total)])
  y = d3.scaleLinear().range([height, 0])

  histogram = d3.histogram().value((d) ->
    d.parsed_total
  ).domain(x.domain()).thresholds(x.ticks(20))

  svg = d3.select("#normal_dist").append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")")
  bins = histogram(data)
  y.domain([0, d3.max(bins, (d) ->  d.length )])
  svg.selectAll("rect").data(bins).enter().append("rect").attr("class", "bar").attr("x", 1).attr("transform", (d) ->
    "translate(" + x(d.x0) + "," + y(d.length) + ")"
  ).attr("width", (d) -> 
    x(d.x1) - x(d.x0) - 1
  ).attr("height", (d) ->
    height - y(d.length)
  )
  svg.append("g").attr("transform", "translate(0," + height + ")").call(d3.axisBottom(x))
  svg.append("g").call(d3.axisLeft(y))

render_orders_histogram = (data) ->
  margin = {top: 10, right: 30, bottom: 30, left: 40}
  width = 960 - margin.left - margin.right
  height = 500 - margin.top - margin.bottom

  # parseDate = d3.timeParse("%d-%m-%Y")

  x = d3.scaleTime().domain([new Date(2010, 6, 3), new Date(2018, 6, 3)]).rangeRound([0, width])
  y = d3.scaleLinear().range([height, 0])

  histogram = d3.histogram().value((d) ->
    d.date
  ).domain(x.domain()).thresholds(x.ticks(d3.timeMonth))

  svg = d3.select("#orders_histogram").append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")")
  bins = histogram(data)
  y.domain([0, d3.max(bins, (d) ->  d.length )])
  svg.selectAll("rect").data(bins).enter().append("rect").attr("class", "bar").attr("x", 1).attr("transform", (d) ->
    "translate(" + x(d.x0) + "," + y(d.length) + ")"
  ).attr("width", (d) -> 
    x(d.x1) - x(d.x0) - 1
  ).attr("height", (d) ->
    height - y(d.length)
  )
  svg.append("g").attr("transform", "translate(0," + height + ")").call(d3.axisBottom(x))
  svg.append("g").call(d3.axisLeft(y))

# $(document).on 'turbolinks:load', ->
#   if $('#orders_histogram').length > 0
#     $.get '/orders.json', (data) ->
#       data.forEach((d) ->
#         d.date = new Date(d.created_at)
#         d.parsed_total = parseFloat(d.total_price)
#       )
#       render_orders_histogram(data)
#       render_orders_price_dist(data)