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
      state: 'modal.maturity-levels'
      config:
        url: '/maturity-levels'
        views:
          "modal":
            templateUrl: 'app/overlays/maturity-levels.html'

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

    {
      state: 'modal.contact'
      config:
        url: '/contact'
        views:
          "modal":
            templateUrl: 'app/overlays/contact.html'
            controller: 'Contact'

    }


 ]

angular.module('app.overlays').run appRun
appRun.$inject = [ 'routerHelper' ]
