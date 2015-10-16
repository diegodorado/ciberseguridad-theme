appRun = (routerHelper) ->
  routerHelper.configureStates getStates()

getStates = ->
  [


    {
      state: 'modal.maturity-levels'
      config:
        url: '/maturity-levels'
        views:
          "modal":
            templateUrl: 'app/maturity-levels/index.html'
            controller: 'MaturityLevels'

          "general@modal.maturity-levels":
            templateUrl: 'app/maturity-levels/general.html'
          "indicator@modal.maturity-levels":
            template: ''
    }

    {
      state: 'modal.maturity-levels.indicator'
      config:
        url: '/dimension/:dimension_id/factor/:factor_id/indicator/:indicator_id/country/:country'
        params:
          indicator_id:
            value: ''
            squash: false
          country:
            value: ''
            squash: false
        views:
          "general@modal.maturity-levels":
            template: ''
          "indicator@modal.maturity-levels":
            templateUrl: 'app/maturity-levels/indicator.html'
            controller: 'Indicator'

    }



 ]

angular.module('app.maturity-levels').run appRun
appRun.$inject = [ 'routerHelper' ]
