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
    $scope.mls = [c.maturity_levels[$scope.$stateParams.indicator_id]]
  else
    $scope.mls = [1..5]

  $scope.toggleIndicator = (indicator) ->
    if parseInt($scope.$stateParams.indicator_id,10) is indicator.id
      $scope.$stateParams.indicator_id = ''
    else
      $scope.$stateParams.indicator_id = indicator.id
      
    $scope.mls = [1..5]
    #dont update, because of close button of overlay with go back behaviour
    #$scope.updateUrl()

  $scope.toggleMl = (i) ->
    if $scope.mls.indexOf(i) is -1
      $scope.mls.push i
    else
      $scope.mls.splice $scope.mls.indexOf(i), 1


angular.module('app.maturity-levels').controller 'Indicator', Indicator
Indicator.$inject = [
  '$scope'
]
