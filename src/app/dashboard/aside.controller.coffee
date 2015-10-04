Aside = ($scope) ->

  $scope.deselectAll = ->
    $scope.countrySelectOpened = false
    $scope.toggleCountriesOff()

  $scope.clickCountry = (code) ->
    $scope.toggleCountry(code)

  $scope.countrySelectOpened = false
  $scope.toggleCountrySelect = ->
    $scope.countrySelectOpened = not $scope.countrySelectOpened
    return

  $scope.countrySelectClickout = ->
    if $scope.countrySelectOpened
      $scope.countrySelectOpened = false

  return

Aside.$inject = [
  '$scope'
]

angular.module('app.dashboard').controller 'Aside', Aside
