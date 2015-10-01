MapCtrl = ($scope) ->

  width = 960
  height = 960
  scale0 = (width - 1) / 2 / Math.PI
  projection = d3.geo.mercator()
  zoom = d3.behavior.zoom().translate([
    width / 2
    height / 2
  ]).scale(scale0).scaleExtent([
    scale0
    8 * scale0
  ]).on('zoom', zoomed)
  path = d3.geo.path().projection(projection)
  svg = d3.select('#map_holder').append('svg').attr('width', width).attr('height', height).append('g')
  svg.append('rect').attr('class', 'overlay').attr('width', width).attr 'height', height

  g = svg.append('g')
  svg.call zoom

  updateSelection = ->
    codes = $scope.$stateParams.countries.split('-')
    g.selectAll("#countries path").attr('class', (d) ->
      if d.id is $scope.$stateParams.last_selected
        'last_selected'
      else
        if codes.indexOf(d.id) > -1 then 'selected' else 'land'
    )

  zoomed = ->
    console.log(11)
    projection.translate(zoom.translate()).scale zoom.scale()
    g.selectAll('path').attr 'd', path
    return

  country_clicked = (d) ->
    updateSelection()
    $scope.toggleCountry(d.id)

  geodata = []
  d3.json 'data/america.json', (error, world) ->
    if error
      throw error

    geodata = topojson.feature(world, world.objects.america).features
    for d in geodata
      d.id = d.id.toLowerCase()

    g.append('g').attr('id', 'countries').selectAll('path').data(geodata).enter().append('path').attr('id', (d) ->
      d.id
    ).attr('d', path).on 'click', country_clicked

    g.append('path').datum(topojson.mesh(world, world.objects.america, (a, b) ->
      a != b
    )).attr('class', 'boundary').attr 'd', path

    updateSelection()

    return

  $scope.$on 'country-toggled', (event, args) ->
    updateSelection()

  $scope.$on 'data-loaded', (event, args) ->
    updateSelection()

  $scope.$on 'breakpoint:change', (event, args) ->
    updateStyle()


  return

MapCtrl.$inject = [
  '$scope'
]

angular.module('app.dashboard').controller 'MapCtrl', MapCtrl
