MapCtrl = ($scope, $window) ->
  d3 = $window.d3
  topojson = $window.topojson

  map_holder = d3.select("#map_holder")
  #map_holder.transition().duration(1000).style("background-color", "black")

  width = parseInt(map_holder.style("width"), 10)
  height = parseInt(map_holder.style("height"), 10)
  scale0 = 350
  projection = d3.geo.mercator()
  path = d3.geo.path().projection(projection)
  svg = d3.select('#map_holder').append('svg').attr('width', width).attr('height', height)
  sea = svg.append('rect').attr('class', 'overlay').attr('width', width).attr('height', height)
  g = svg.append('g')

  zoomed = ->
    t = zoom.translate()
    s = zoom.scale()
    console.log 'zoomed', t, s
    #g.transition().attr('transform', 'translate('+t[0]+','+t[1]+')scale('+s+')')
    #projection.translate(t).scale s
    #g.selectAll('path').attr 'd', path
    return

  initZoom = ->
    t = zoom.translate()
    s = zoom.scale()
    console.log 'initZoom', t, s
    #g.transition().attr('transform', 'translate('+t[0]+','+t[1]+')scale('+s+')')
    projection.translate(t).scale s
    g.selectAll('path').attr 'd', path

  zoom = d3.behavior.zoom().translate([
    width / 2 + 450
    height / 2 - 100
  ]).scale(scale0).scaleExtent([
    scale0
    100 * scale0
  ]).on('zoom', zoomed)

  svg.call(zoom).call(zoom.event)

  svg.call(initZoom)

  updateZoom = ->
    if $scope.$stateParams.last_selected is ''
      zoom_and_center()
    else
      for d in g.selectAll('#countries path').data()
        if d.id is $scope.$stateParams.last_selected
          zoom_and_center(d)

  updateSelection = ->
    updateZoom()

    codes = $scope.$stateParams.countries.split('-')
    g.selectAll('#countries path').attr('class', (d) ->
      if d.banned
        'banned'
      else if d.id is $scope.$stateParams.last_selected
        'last_selected'
      else
        if codes.indexOf(d.id) > -1 then 'selected' else 'land'
    )


  sea_clicked = ->
    if zoomed
      zoom_and_center()
    else
      updateZoom()

  sea.on 'click', sea_clicked

  country_clicked = (d) ->
    zoom_and_center(d)
    unless d.banned
      updateSelection()
      $scope.toggleCountry(d.id)

  zoomed = false
  zoom_and_center = (d) ->
    x = undefined
    y = undefined
    k = undefined
    if d and d.id is $scope.$stateParams.last_selected
      b = path.bounds(d)
      w_scale = (b[1][0] - (b[0][0])) / width
      h_scale = (b[1][1] - (b[0][1])) / height
      k = .5 / Math.max(w_scale, h_scale)
      x = (b[1][0] + b[0][0]) / 2
      y = (b[1][1] + b[0][1]) / 2
      zoomed = true
    else
      x = width / 2
      y = height / 2
      k = 1
      zoomed = false

    g.transition().duration(1000).attr('transform', 'translate(' + width / 2 + ',' + height / 2 + ')scale(' + k + ')translate(' + -x + ',' + -y + ')')
    return


  geodata = []
  d3.json 'data/countries.json', (error, data) ->
    if error
      throw error

    geodata = topojson.feature(data, data.objects.countries).features
    for d in geodata
      d.id = d.id.toLowerCase()
      d.banned = (c.code for c in $scope.countries).indexOf(d.id) is -1

    g.append('g').attr('id', 'countries').selectAll('path').data(geodata).enter().append('path').attr('id', (d) ->
      d.id
    ).attr('d', path).on 'click', country_clicked

    g.append('path').datum(topojson.mesh(data, data.objects.countries, (a, b) ->
      a != b
    )).attr('class', 'boundary').attr 'd', path

    #g.transition().duration(750).attr('transform', 'translate(-280,-170)scale(2,2)')
    updateSelection()

    return

  $scope.$on 'country-toggled', (event, args) ->
    updateSelection()

  $scope.$on 'data-loaded', (event, args) ->
    updateSelection()

  $scope.$on 'breakpoint:change', (event, args) ->
    console.log 'breakpoint:change'


  return

MapCtrl.$inject = [
  '$scope'
  '$window'
]

angular.module('app.dashboard').controller 'MapCtrl', MapCtrl
