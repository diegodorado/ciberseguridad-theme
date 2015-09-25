### @ngInject ###
configure = ($compileProvider,
  $logProvider,
  routerHelperProvider,
  exceptionHandlerProvider,
  $translateProvider
  ) ->

  configureStateHelper = ->

    routerHelperProvider.configure
      docTitle: 'CiberSeguridad: '
      resolveAlways: ready: (dataservice) ->
        dataservice.getData()

    return

  $compileProvider.debugInfoEnabled false
  # turn debugging off/on (no info or warn)
  if $logProvider.debugEnabled
    $logProvider.debugEnabled true
  exceptionHandlerProvider.configure config.appErrorPrefix
  configureStateHelper()

  themeUrl = (meta.getAttribute("content") for meta in document.getElementsByTagName('meta') when meta.getAttribute("name") is "themeUrl")[0]

  $translateProvider
    .useStaticFilesLoader({
      prefix: themeUrl + '/assets/lang/',
      suffix: '.json'
    })  #.useUrlLoader('/api/messages')
    .preferredLanguage('es')
    .fallbackLanguage('es')
    .useLocalStorage()
    .useMissingTranslationHandlerLog()
    .useSanitizeValueStrategy(null)


configure.$inject = [
    '$compileProvider'
    '$logProvider'
    'routerHelperProvider'
    'exceptionHandlerProvider'
    '$translateProvider'
]


core = angular.module('app.core')

core.run [
  '$rootScope'
  '$state'
  '$stateParams'
  '$translate'
  '$window'
  ($rootScope, $state, $stateParams, $translate, $window) ->
    # It's very handy to add references to $state and $stateParams to the
    # $rootScope so that you can access them from any scope within your
    # applications. For example, <li ng-class="{ active: $state.includes
    # ('contacts.list') }"> will set the <li>  to active whenever
    #'contacts.list' or one of its decendents is active.
    $rootScope.$state = $state
    $rootScope.$stateParams = $stateParams

    $translate.use($translate.proposedLanguage())
    $rootScope.locale = $translate.use() or $translate.proposedLanguage()

    $rootScope.breakpoint = null

    refreshBreakpoint = ->
      s = $window.getComputedStyle(document.querySelector('body'), ':before')
      v = s.getPropertyValue('content').replace(/\"/g, '')
      if $rootScope.breakpoint isnt v
        $rootScope.breakpoint = v
        $rootScope.$broadcast('breakpoint:change')

    refreshBreakpoint()

    angular.element($window).on 'resize', () ->
      refreshBreakpoint()

    $rootScope.updateUrl = ->
      $state.go($state.current, $stateParams, {notify: false})


]

config =
  appErrorPrefix: '[GulpPatterns Error] '
  appTitle: 'Gulp Patterns Demo'

core.value 'config', config
core.config configure
