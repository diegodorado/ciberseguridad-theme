getStates = ->
  [
    #exists only to be redirected
    {
      state: 'app'
      abstract: true
      config:
        url: '/'
        views:
          "header":
            templateUrl: 'app/layout/header.html'
            controller: 'Header'
          "footer":
            templateUrl: 'app/layout/footer.html'
            controller: 'Footer'

    }

    {
      state: 'app.graph'
      config:
        url: 'graph/countries/:countries/selected/:last_selected/' +
          ':offset/dimensions/:expanded_dimensions'
        params:
          countries:
            value: ''
            squash: false
          last_selected:
            value: ''
            squash: false
          offset:
            value: '0'
            squash: false
          expanded_dimensions:
            value: '1-2-3-4-5'
            squash: false
        title: 'Home'
        views:
          "content@":
            templateUrl: 'app/dashboard/dashboard.html'
            controller: 'Dashboard'
          "aside@app.graph":
            templateUrl: 'app/dashboard/aside.html'
            controller: 'Aside'
          "eq@app.graph":
            templateUrl: 'app/dashboard/eq.html'
            controller: 'Eq'
          "map@app.graph":
            templateUrl: 'app/dashboard/map.html'
            controller: 'MapCtrl'
            controllerAs: 'vm'
          "graph@app.graph":
            templateUrl: 'app/dashboard/graph.html'
            controller: 'Graph'
          "stats@app.graph":
            templateUrl: 'app/dashboard/stats.html'
            controller: 'Stats'
    }

    {
      state: 'app.about'
      config:
        url: ':locale/about'
        views:
          "content@":
            templateUrl:  ($stateParams) ->
              return '/about-' + $stateParams.locale + '.html'
        title: 'about'
    }

    {
      state: 'app.contributors'
      config:
        url: ':locale/contributors'
        views:
          "content@":
            templateUrl: ($stateParams) ->
              return '/contributors-' + $stateParams.locale + '.html'
        title: 'contributors'
    }

    {
      state: 'app.institutional-information'
      config:
        url: ':locale/institutional-information'
        views:
          "content@":
            templateUrl: ($stateParams) ->
              return '/institutional-information-' +
                $stateParams.locale + '.html'
        title: 'institutional-information'
    }


  ]

### @ngInject ###
appRun = (routerHelper) ->
  routerHelper.configureStates getStates(), '/'
appRun.$inject = [ 'routerHelper' ]

angular.module('app.dashboard').run appRun
