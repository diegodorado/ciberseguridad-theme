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
          "factor@modal.maturity-levels":
            template: ''
          "indicator@modal.maturity-levels":
            template: ''
    }

    {
      state: 'modal.maturity-levels.factor'
      config:
        url: '/dimension/:dimension_id/factor/:factor_id'
        params:
          dimension_id:
            value: ''
            squash: true
          factor_id:
            value: ''
            squash: true
        views:
          "general@modal.maturity-levels":
            template: ''
          "factor@modal.maturity-levels":
            templateUrl: 'app/maturity-levels/factor.html'
          "indicator@modal.maturity-levels":
            template: ''

    }

    {
      state: 'modal.maturity-levels.factor.indicator'
      config:
        url: '/indicator/:indicator_id/:maturity_level'
        params:
          indicator_id:
            value: ''
            squash: true
          maturity_level:
            value: ''
            squash: true
        views:
          "general@modal.maturity-levels":
            template: ''
          "factor@modal.maturity-levels":
            template: ''
          "indicator@modal.maturity-levels":
            templateUrl: 'app/maturity-levels/indicator.html'
            controller: 'Indicator'

    }



 ]

angular.module('app.maturity-levels').run appRun
appRun.$inject = [ 'routerHelper' ]
