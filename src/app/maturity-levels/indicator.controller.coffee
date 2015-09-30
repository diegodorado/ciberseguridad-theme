### @ngInject ###
Indicator = ($scope) ->

  i_id = $scope.$stateParams.indicator_id
  i = (i for i in $scope.factor.indicators  when ''+i.id is i_id)[0]
  $scope.indicator = i

  return

angular.module('app.maturity-levels').controller 'Indicator', Indicator
Indicator.$inject = [
  '$scope'
]
