MapCtrl = ($scope, $window) ->
  d3 = $window.d3
  topojson = $window.topojson

  width = 0
  height = 0
  active = false
  scale0 = 350
  zoomed = false
  geodata = []

  zoomed = (args) ->
    return unless active

    console.log arguments
    t = zoom.translate()
    s = zoom.scale()/scale0
    console.log 'zoomed', t[0]/s, t[1]/s, s
    #g.attr('transform', 'translate('+t[0]+','+t[1]+')scale('+s+')')
    #projection.translate(t).scale s
    #g.selectAll('path').attr 'd', path
    return

  updateSize = ->
    active = false
    large = $scope.breakpoint is 'large'
    wide = $scope.breakpoint is 'wide'
    if large or wide
      map_holder = d3.select("#map_holder")
      width = parseInt(map_holder.style("width"), 10)
      height = parseInt(map_holder.style("height"), 10)
      svg.attr('width', width).attr('height', height)
      sea.attr('width', width).attr('height', height)
      if large
        scale0 = 300
        zoom.translate([ width / 2 + 420, height / 2 - 100])
      else
        scale0 = 350
        zoom.translate([ width / 2 + 500, height / 2 - 100])

      zoom.scale(scale0).scaleExtent([ scale0, 100 * scale0 ])
      projection.translate(zoom.translate()).scale zoom.scale()
      g.selectAll('path').attr 'd', path
      active = true
      updateSelection()

  updateZoom = ->
    return unless active

    if $scope.$stateParams.last_selected is ''
      zoom_and_center()
    else
      for d in g.selectAll('#countries path').data()
        if d.id is $scope.$stateParams.last_selected
          zoom_and_center(d)

  updateSelection = ->
    return unless active

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

  country_clicked = (d) ->
    unless d.banned
      $scope.toggleCountry(d.id)


  zoom_and_center = (d) ->
    x = width / 2
    y = height / 2
    k = 1
    zoomed = false

    if d and d.id is $scope.$stateParams.last_selected
      b = path.bounds(d)
      w_scale = (b[1][0] - (b[0][0])) / width
      h_scale = (b[1][1] - (b[0][1])) / height
      k = .5 / Math.max(w_scale, h_scale)
      x = (b[1][0] + b[0][0]) / 2
      y = (b[1][1] + b[0][1]) / 2
      zoomed = true

    transform = 'translate(' + width / 2 + ',' + height / 2 + ')
                  scale(' + k + ')translate(' + -x + ',' + -y + ')'
    g.transition().duration(750).attr('transform', transform)
    return

  projection = d3.geo.mercator()
  path = d3.geo.path().projection(projection)
  svg = d3.select('#map_holder').append('svg')
  sea = svg.append('rect').attr('class', 'overlay')
  sea.on 'click', sea_clicked
  g = svg.append('g')
  zoom = d3.behavior.zoom().on('zoom', zoomed)

  updateSize()
  #svg.call(zoom)

  d3.json $scope.themeUrl + '/assets/geodata/countries.json', (error, data) ->
    if error
      throw error

    geodata = topojson.feature(data, data.objects.countries).features
    for d in geodata
      d.id = d.id.toLowerCase()
      d.banned = (c.code for c in $scope.countries).indexOf(d.id) is -1

    g.append('g').attr('id', 'countries').selectAll('path').data(geodata
    ).enter().append('path').attr('d', path).on 'click', country_clicked

    g.append('path').datum(topojson.mesh(data, data.objects.countries, (a, b) ->
      a != b
    )).attr('class', 'boundary').attr 'd', path

    updateSelection()

    return

  $scope.$on 'country-toggled', (event, args) ->
    updateSelection()

  $scope.$on 'data-loaded', (event, args) ->
    updateSelection()

  $scope.$on 'breakpoint:change', (event, args) ->
    updateSize()


  return

MapCtrl.$inject = [
  '$scope'
  '$window'
]

angular.module('app.dashboard').controller 'MapCtrl', MapCtrl
