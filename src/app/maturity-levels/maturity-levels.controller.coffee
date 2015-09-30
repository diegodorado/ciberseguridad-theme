### @ngInject ###
MaturityLevels = ($scope) ->

  d_id = $scope.$stateParams.dimension_id
  d = (d for d in $scope.dimensions when ''+d.id is d_id)[0]
  $scope.dimension = d
  if d
    f_id = $scope.$stateParams.factor_id
    f = (f for f in d.factors when ''+f.id is f_id)[0]
    $scope.factor = f

  return

angular.module('app.maturity-levels').controller 'MaturityLevels', MaturityLevels
MaturityLevels.$inject = [
  '$scope'
]
