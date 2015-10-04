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


    {
      state: 'modal.country-details'
      config:
        url: '/country-details/:code'
        views:
          "modal":
            templateUrl: 'app/overlays/country-details.html'
            controller: 'CountryDetails'

    }

 ]

angular.module('app.overlays').run appRun
appRun.$inject = [ 'routerHelper' ]
