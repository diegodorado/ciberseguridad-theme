Eq = ($scope, $rootScope) ->

  #not used
  updateHeight = () ->
    map = document.getElementById('map_holder')
    right = map.parentNode.parentNode
    h = document.getElementsByClassName("eq")[0].clientHeight
    console.log h
    map.style = right.style = "height:#{100+h}px"
    $rootScope.$broadcast('breakpoint:change')


  return

Eq.$inject = [
  '$scope'
  '$rootScope'
]

angular.module('app.dashboard').controller 'Eq', Eq
