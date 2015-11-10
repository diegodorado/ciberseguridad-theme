### @ngInject ###
Country = ($scope,$window, $stateParams) ->

  $scope.close = () ->
    $window.history.back()

  @init = () ->
    c = (c for c in $scope.countries when c.code is $stateParams.code)[0]
    $scope.country = c

  $scope.$on 'data-loaded', (event, args) =>
    @init()

  @init()

  return

angular.module('app.country').controller 'Country', Country
Country.$inject = [
  '$scope'
  '$window'
  '$stateParams'
]
