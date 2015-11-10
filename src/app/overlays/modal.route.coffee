appRun = (routerHelper) ->
  routerHelper.configureStates getStates()

getStates = ->
  [
    {
      state: 'modal'
      config:
        views:
          "modal":
            templateUrl: 'app/overlays/modal.html'
            controller: 'Modal'
        abstract: true

    }
 ]

angular.module('app.overlays').run appRun
appRun.$inject = [ 'routerHelper' ]
