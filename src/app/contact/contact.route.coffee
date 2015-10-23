appRun = (routerHelper) ->
  routerHelper.configureStates getStates()

getStates = ->
  [
    {
      state: 'app.contact'
      config:
        bodyClass: 'contact'
        url: 'contact'
        views:
          "content@":
            templateUrl: 'app/contact/contact.html'
            controller: 'Contact'
    }
 ]

angular.module('app.contact').run appRun
appRun.$inject = [ 'routerHelper' ]
