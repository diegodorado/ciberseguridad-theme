### @ngInject ###
dataservice = ($http, $rootScope, $q) ->
  #topojson = $window.topojson

  $rootScope.countries = []
  $rootScope.dimensions = []
  $rootScope.geodata = []
  $rootScope.geomesh = null

  promises = []

  @getData = (locale)->

    if !promises['geo']
      promises['geo'] = $http.get($rootScope.themeUrl +
        '/assets/geodata/countries.json')

    if !promises[locale]

      dataP = $http.get('/api/'+locale+'/all')

      promises[locale] = $q.all([dataP, promises['geo']]).then( (response) ->
        response
      )

    return promises[locale]

  @prepareData = ->
    locale = $rootScope.locale
    @getData(locale).then( (resp) ->
      document.documentElement.setAttribute('lang', locale)
      $rootScope.countries = resp[0].data.countries
      $rootScope.dimensions = resp[0].data.dimensions

      $rootScope.geodata = topojson
        .feature(resp[1].data, resp[1].data.objects.countries).features
      for d in $rootScope.geodata
        d.id = d.id.toLowerCase()
        d.banned = (c.code for c in $rootScope.countries).indexOf(d.id) is -1

      $rootScope.geomesh = topojson.mesh(resp[1].data,
        resp[1].data.objects.countries, (a, b) -> a != b )


      $rootScope.$broadcast 'data-loaded'
    )

  $rootScope.$on '$translateChangeStart', (event, eventData) =>
    locale = eventData.language
    $rootScope.locale =  locale
    if $rootScope.$stateParams.locale
      $rootScope.$stateParams.locale = locale
      #$rootScope.updateUrl()
      $rootScope.$state.go($rootScope.$state.current, $rootScope.$stateParams, {notify: true})

    @prepareData()



  @submitContact = (data)->
    $http.post('/api/'+$rootScope.locale+'/contact', data)

  @submitShare = (data)->
    $http.post('/api/'+$rootScope.locale+'/share', data)

  return @

dataservice.$inject = [
  '$http'
  '$rootScope'
  '$q'
]


angular.module('app.core').factory 'dataservice', dataservice
