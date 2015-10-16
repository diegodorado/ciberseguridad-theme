### @ngInject ###
Indicator = ($scope) ->

  d_id = $scope.$stateParams.dimension_id
  d = (d for d in $scope.dimensions  when d.id+'' is d_id)[0]
  $scope.dimension = d

  f_id = $scope.$stateParams.factor_id
  f = (f for f in d.factors when f.id+'' is f_id)[0]
  $scope.factor = f

  code = $scope.$stateParams.country
  if code
    c = (c for c in $scope.countries  when c.code is code)[0]
    $scope.country = c
    $scope.ml = c.maturity_levels[$scope.$stateParams.indicator_id]

  $scope.toggleIndicator = (indicator) ->
    if parseInt($scope.$stateParams.indicator_id,10) is indicator.id
      $scope.$stateParams.indicator_id = ''
    else
      $scope.$stateParams.indicator_id = indicator.id

    #$scope.updateUrl()

  $scope.toggleMl = (i) ->
    return
    
    if $scope.ml is i
      $scope.ml = null
    else
      $scope.ml = i


angular.module('app.maturity-levels').controller 'Indicator', Indicator
Indicator.$inject = [
  '$scope'
]
