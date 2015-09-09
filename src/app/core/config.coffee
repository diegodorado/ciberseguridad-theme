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
    .determinePreferredLanguage()

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
  'dataservice'
  '$translate'
  ($rootScope, $state, $stateParams, dataservice, $translate) ->
    # It's very handy to add references to $state and $stateParams to the
    # $rootScope so that you can access them from any scope within your
    # applications. For example, <li ng-class="{ active: $state.includes
    # ('contacts.list') }"> will set the <li>  to active whenever
    #'contacts.list' or one of its decendents is active.
    $rootScope.$state = $state
    $rootScope.$stateParams = $stateParams

    $rootScope.countries = []
    $rootScope.dimensions = []
    $rootScope.locale = $translate.proposedLanguage()

    refreshData = (locale)->
      locale or= $translate.use() or $translate.proposedLanguage()

      document.documentElement.setAttribute('lang', locale)
      dataservice.getData(locale).then (response) ->
        $rootScope.countries = response.data.countries
        $rootScope.dimensions = response.data.dimensions
        $rootScope.locale = locale
        $rootScope.$broadcast 'data-loaded'


    $rootScope.$on '$translateChangeStart', (event, data) =>
      refreshData(data.language)


    refreshData()


]

config =
  appErrorPrefix: '[GulpPatterns Error] '
  appTitle: 'Gulp Patterns Demo'

core.value 'config', config
core.config configure
