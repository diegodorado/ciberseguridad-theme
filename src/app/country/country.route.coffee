appRun = (routerHelper) ->
  routerHelper.configureStates getStates()

getStates = ->
  [
    {
      state: 'app.country'
      config:
        bodyClass: 'country'
        url: '/country/:code'
        views:
          "content@":
            templateUrl: 'app/country/country.html'
            controller: 'Country'

    }

 ]

angular.module('app.country').run appRun
appRun.$inject = [ 'routerHelper' ]
