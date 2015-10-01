MapCtrl = ($scope) ->

  $scope.mapPlugins =
    bubbles: null
    customLegend: (layer, data, options) ->
      html = [ '<ul class="list-inline">' ]
      label = ''
      for fillKey of @options.fills
        html.push '<li class="key" ', 'style="border-top: 10px solid ' + @options.fills[fillKey] + '">', fillKey, '</li>'
      html.push '</ul>'
      d3.select(@options.element).append('div').attr('class', 'datamaps-legend').html html.join('')
      return
  $scope.mapPluginData = bubbles: [ {
    name: 'Bubble 1'
    latitude: 21.32
    longitude: -7.32
    radius: 45
    fillKey: 'gt500'
  } ]

  $scope.mapObject =
    scope: 'world'
    responsive: true
    options:
      width: 1110
      legendHeight: 60
    geographyConfig:
      highlighBorderColor: '#EAA9A8'
      highlighBorderWidth: 2
    fills:
      'HIGH': '#CC4731'
      'MEDIUM': '#306596'
      'LOW': '#667FAF'
      'defaultFill': '#DDDDDD'
    data:
      'AZ': 'fillKey': 'MEDIUM'
      'CO': 'fillKey': 'HIGH'
      'DE': 'fillKey': 'LOW'
      'GA': 'fillKey': 'MEDIUM'

  $scope.updateActiveGeography = (geography) ->
    console.log geography
    geography.properties.name = "QWPOIUUE"
    $scope.stateName = geography.properties.name
    $scope.stateCode = geography.id

  loadChart = ->
    $scope.chart.data = [['region', 'color']]
    for c in $scope.countries
      color = 0
      if c.code is $scope.$stateParams.last_selected
        color = 2
      else if $scope.$stateParams.countries.indexOf(c.code) > -1
        color = 1

      $scope.chart.data.push [c.code, color]

    return

  updateStyle = ->
    if $scope.breakpoint is 'wide'
      if $scope.$stateParams.zone is '0'
        $scope.chartStyle =
          top: '-220px'
          left: '0px'
        $scope.chart.options.width = 700
        $scope.chart.options.height = 1200
        $scope.chart.options.region = '013'
      if $scope.$stateParams.zone is '1'
        $scope.chartStyle =
          top: '40px'
          left: '-90px'
        $scope.chart.options.width = 800
        $scope.chart.options.height = 800
        $scope.chart.options.region = '029'
      if $scope.$stateParams.zone is '2'
        $scope.chartStyle =
          top: '-680px'
          left: '-860px'
        $scope.chart.options.width = 2200
        $scope.chart.options.height = 1500
        #$scope.chart.options.region = '005'
        $scope.chart.options.region = '019'

    if $scope.breakpoint is 'large'
      if $scope.$stateParams.zone is '0'
        $scope.chartStyle =
          top: '-220px'
          left: '40px'
        $scope.chart.options.width = 500
        $scope.chart.options.height = 1200
        $scope.chart.options.region = '013'
      if $scope.$stateParams.zone is '1'
        $scope.chartStyle =
          top: '40px'
          left: '-120px'
        $scope.chart.options.width = 700
        $scope.chart.options.height = 700
        $scope.chart.options.region = '029'
      if $scope.$stateParams.zone is '2'
        $scope.chartStyle =
          top: '-680px'
          left: '-940px'
        $scope.chart.options.width = 2200
        $scope.chart.options.height = 1500
        $scope.chart.options.region = '019'


  $scope.chartStyle = {}

  $scope.chart =
    type: 'GeoChart'
    data: [['region', 'color'],['ar', 0]]
    options:
      colorAxis:
        values: [0,1,2]
        colors: ['#D4D5D6','#A7A9AB','#58585B']
      backgroundColor: 'transparent'
      datalessRegionColor: 'transparent'
      defaultColor: '#D4D5D6'
      displayMode: 'regions'
      region: '019'
      legend: 'none'
      tooltip:
        trigger: 'none'

  $scope.changeZoom = (zoom_level) ->
    $scope.$stateParams.zone = zoom_level
    updateStyle()
    $scope.updateUrl()

  $scope.chartOnReady = (chartWrapper) ->
    $scope.chartWrapper = chartWrapper

  $scope.chartOnSelect = (selectedItem) ->
    dt = $scope.chartWrapper.getDataTable()
    code = $scope.$stateParams.last_selected
    if selectedItem?
      code = dt.getValue(selectedItem.row,0)

    $scope.toggleCountry(code)

  $scope.$on 'country-toggled', (event, args) ->
    loadChart()

  $scope.$on 'data-loaded', (event, args) ->
    loadChart()

  $scope.$on 'breakpoint:change', (event, args) ->
    updateStyle()

  updateStyle()
  loadChart()
  return

MapCtrl.$inject = [
  '$scope'
]

angular.module('app.dashboard').controller 'MapCtrl', MapCtrl
