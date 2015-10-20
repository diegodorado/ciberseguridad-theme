### Help configure the state-base ui.router ###
### @ngInject ###
routerHelperProvider = ($locationProvider, $stateProvider, $urlRouterProvider) ->

  ### jshint validthis:true ###
  config =
    docTitle: undefined
    resolveAlways: {}

  ### @ngInject ###
  RouterHelper = ($location, $rootScope, $state, logger, $anchorScroll) ->
    handlingStateChangeError = false
    hasOtherwise = false
    stateCounts =
      errors: 0
      changes: 0

    configureStates = (states, otherwisePath) ->
      states.forEach (state) ->
        state.config.resolve = angular.extend(state.config.resolve or {}, config.resolveAlways)
        $stateProvider.state state.state, state.config

      if otherwisePath and !hasOtherwise
        hasOtherwise = true
        $urlRouterProvider.otherwise otherwisePath


    handleRoutingErrors = ->
      # Route cancellation:
      # On routing error, go to the dashboard.
      # Provide an exit clause if it tries to do it twice.
      $rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, error) ->

        formatErrorMessage = (error) ->
          dest = toState and (toState.title or toState.name or toState.loadedTemplateUrl) or 'unknown target'
          'Error routing to ' + dest + '. ' + error.message or error.data or '' + '. <br/>' + (error.statusText or '') + ': ' + (error.status or '')

        if handlingStateChangeError
          return

        stateCounts.errors++
        handlingStateChangeError = true
        msg = formatErrorMessage(error)
        logger.warning msg, [ toState ]
        $location.path '/'


    init = ->
      handleRoutingErrors()
      updateDocTitle()
      setupInitialUrl()


    getStates = ->
      $state.get()

    setupInitialUrl = ->
      $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
        if toState.name is 'app'
          event.preventDefault()
          $state.go('app.graph')

    updateDocTitle = ->
      $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
        stateCounts.changes++
        handlingStateChangeError = false
        title = config.docTitle + ' ' + (toState.title or '')
        $rootScope.title = title
        $anchorScroll()

    service =
      configureStates: configureStates
      getStates: getStates
      stateCounts: stateCounts


    init()
    return service

  $locationProvider.html5Mode true

  @configure = (cfg) ->
    angular.extend config, cfg

  @$get = RouterHelper
  RouterHelper.$inject = [
    '$location'
    '$rootScope'
    '$state'
    'logger'
    '$anchorScroll'

  ]
  return

routerHelperProvider.$inject = [
  '$locationProvider'
  '$stateProvider'
  '$urlRouterProvider'
]


angular.module('blocks.router').provider 'routerHelper', routerHelperProvider
