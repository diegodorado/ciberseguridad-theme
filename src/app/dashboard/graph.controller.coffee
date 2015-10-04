Graph = ($scope, $http) ->

  $scope.downloadLink = ->
    '/api/excel/' + $scope.$stateParams.countries +
      '/' + $scope.$stateParams.expanded_dimensions

  $scope.openSharer = ->
    false

  $scope.nextDisabled = ->
    $scope.$stateParams.offset >=
      $scope.countriesSelected() - $scope.countriesPerPage()

  $scope.prevDisabled = ->
    $scope.$stateParams.offset <= 0


  $scope.next = ->
    unless $scope.nextDisabled()
      $scope.$stateParams.offset++
      $scope.updateUrl()

  $scope.prev = ->
    unless $scope.prevDisabled()
      $scope.$stateParams.offset--
      $scope.updateUrl()

  $scope.navCountrySelectClickout = ->
    if $scope.navCountrySelectOpened
      $scope.navCountrySelectOpened = false

  $scope.countrySelectClickout = ->
    if $scope.countrySelectOpened
      $scope.countrySelectOpened = false

  $scope.deselectAll = ($event)->
    $scope.navCountrySelectOpened = false
    $scope.countrySelectOpened = false
    $event?.stopPropagation()
    $scope.toggleCountriesOff()

  $scope.clickCountry = (code,$event) ->
    $scope.navCountrySelectOpened = false
    $scope.countrySelectOpened = false
    $event?.stopPropagation()
    $scope.toggleCountry(code)

  $scope.navCountrySelectOpened = false
  $scope.toggleNavCountrySelect = ($event) ->
    $scope.navCountrySelectOpened = not $scope.navCountrySelectOpened
    return

  $scope.countrySelectOpened = false
  $scope.toggleCountrySelect = ($event) ->
    $scope.countrySelectOpened = not $scope.countrySelectOpened
    return

  $scope.toggleDimension = (dimension) ->

    expanded = []
    if $scope.$stateParams.expanded_dimensions isnt 'none'
      expanded = $scope.$stateParams.expanded_dimensions.split('-')


    index = expanded.indexOf(dimension.id.toString())

    if index is -1
      expanded.push dimension.id.toString()
    else
      expanded.splice index, 1

    if expanded.length is 0
      $scope.$stateParams.expanded_dimensions = 'none'
     else
      $scope.$stateParams.expanded_dimensions = expanded.sort().join('-')

    $scope.updateUrl()

  $scope.expandedDimension = (dimension) ->
    if $scope.$stateParams.expanded_dimensions is 'none'
      false
    else
      $scope.$stateParams.expanded_dimensions.indexOf(dimension.id) > -1

  $scope.handleDrop = (codeA, codeB) ->
    codeA = codeA.replace('country-','')
    codeB = codeB.replace('country-','')
    codes = $scope.$stateParams.countries.split('-')
    codes[codes.indexOf(codeA)] = codeB
    codes[codes.indexOf(codeB)] = codeA
    $scope.$stateParams.countries = codes.join('-')
    $scope.updateUrl()


  return

Graph.$inject = [
  '$scope'
  '$http'
]

angular.module('app.dashboard').controller 'Graph', Graph
