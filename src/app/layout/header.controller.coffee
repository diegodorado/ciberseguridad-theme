### @ngInject ###
Header = ($rootScope, $window, $scope , $translate) ->
  $scope.langOpened = false

  updateLinks = ->
    if $scope.locale is 'en'
      $scope.oeaLink = 'http://www.oas.org/en/'
      $scope.bidLink = 'http://www.iadb.org/en/inter-american-development-bank,2837.html'
    else
      $scope.oeaLink = 'http://www.oas.org/es/'
      $scope.bidLink = 'http://www.iadb.org/es/banco-interamericano-de-desarrollo,2837.html'



  $scope.changeLocale = (locale) ->
    $translate.use(locale)
    $scope.toggleMenu()

  $scope.toggleMenu = (event) ->
    $scope.langOpened = not $scope.langOpened
    # Important part in the implementation
    # Stopping event propagation means window.onclick
    # won't get called when someone clicks
    # on the menu div. Without this, menu will be hidden immediately
    if event?
      event.stopPropagation()

  $window.onclick = () ->
    if $scope.langOpened
      $scope.langOpened = false
      # You should let angular know about the update that you have made,
      # so that it can refresh the UI
      $scope.$apply()

  $rootScope.$on '$translateChangeEnd', (event, eventData) ->
    updateLinks()

  updateLinks()



  return

angular.module('app.layout').controller 'Header', Header
Header.$inject = [
  '$rootScope'
  '$window'
  '$scope'
  '$translate'
]
