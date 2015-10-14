Stats = ($scope) ->

  $scope.statsChartHeight = (people) ->
    max = 1 # avoid 0 division
    people = parseInt(people,10)
    populations = (parseInt(c.population,10) for c in $scope.countries when $scope.$stateParams.countries.indexOf(c.code) > -1)
    for p in populations
      if p > max
        max = p

    return Math.round(100*people/max, 0)


  $scope.handleDrop = (codeDragged, codeDropped) ->
    codes = $scope.$stateParams.countries.split('-')
    codes.splice codes.indexOf(codeDragged), 1
    if codeDropped?
      i = codes.indexOf(codeDropped)
      tail = codes.splice(i)
      codes.push codeDragged
      codes.push c for c in tail
    else
      codes.push(codeDragged)

    $scope.$stateParams.last_selected = codeDragged
    $scope.$stateParams.countries = codes.join('-')
    $scope.updateUrl()
    $scope.$parent.$broadcast 'country-toggled'

  return

Stats.$inject = [
  '$scope'
]

angular.module('app.dashboard').controller 'Stats', Stats
