Dashboard = ($scope, $filter, ngToast) ->

  $scope.toggleCountriesOff = ->
    $scope.$stateParams.last_selected = ''
    $scope.$stateParams.countries = ''
    $scope.$stateParams.offset = 0
    $scope.updateUrl()
    $scope.$broadcast 'country-toggled'

  getCodes = ->
    if $scope.$stateParams.countries.length > 0
      $scope.$stateParams.countries.split('-')
    else
      []

  getProperOffset = (codes) ->
    if codes.length > $scope.countriesPerPage()
      codes.length - $scope.countriesPerPage()
    else
      0

  updateOffset = (codes) ->
    offset = getProperOffset(codes)
    unless parseInt($scope.$stateParams.offset,10) is offset
      $scope.$stateParams.offset = offset

  $scope.toggleCountry = (code) ->
    country = (c for c in $scope.countries when c.code is code)[0]
    codes = getCodes()

    index = codes.indexOf(code)
    if index is -1
      $scope.$stateParams.last_selected = code
      codes.push code
      ngToast.create $filter('translate')('pais.agregado',
        {country:country.name})
    else
      codes.splice index, 1
      [..., last] = codes
      $scope.$stateParams.last_selected = if last? then last else ''
      ngToast.create $filter('translate')('pais.quitado',
        {country:country.name})

    if codes.length is 0
      $scope.$stateParams.countries = ''
    else
      $scope.$stateParams.countries = codes.join('-')

    $scope.$stateParams.offset = getProperOffset(codes)

    $scope.updateUrl()
    $scope.$broadcast 'country-toggled'

  $scope.shownCountries = ->
    codes = $scope.$stateParams.countries.split('-')
    selectedCountries = $filter('selectedCountries')($scope.countries,codes)
    offset = $filter('offset')(selectedCountries,$scope.$stateParams.offset)
    $filter('limitTo')(offset,$scope.countriesPerPage())


  $scope.last_selected = ->
    code = $scope.$stateParams.last_selected
    country = (c for c in $scope.countries when c.code is code)[0]
    return country

  $scope.countriesSelected = ->
    if $scope.$stateParams.countries is ''
      0
    else
      $scope.$stateParams.countries.split('-').length


  $scope.$on 'breakpoint:change', (event, args) ->
    $scope.$apply ->
      updateOffset(getCodes())

  $scope.countriesPerPage = ->
    if $scope.breakpoint is 'wide' or $scope.breakpoint is 'large'
      return 5
    else
      return 1

  $scope.showGhostCountry = ->
    $scope.countriesSelected() < $scope.countriesPerPage()

  $scope.showPager = ->
    $scope.countriesSelected() > $scope.countriesPerPage()


  $scope.nextDisabled = ->
    $scope.$stateParams.offset >=
      $scope.countriesSelected() - $scope.countriesPerPage()

  $scope.prevDisabled = ->
    $scope.$stateParams.offset <= 0

  checkOffset = ->
    if $scope.countriesPerPage() is 1
      codes = getCodes()
      $scope.$stateParams.last_selected = codes[$scope.$stateParams.offset]

  $scope.next = ->
    unless $scope.nextDisabled()
      $scope.$stateParams.offset++
      checkOffset()
      $scope.updateUrl()

  $scope.prev = ->
    unless $scope.prevDisabled()
      $scope.$stateParams.offset--
      checkOffset()
      $scope.updateUrl()

  updateOffset(getCodes())
  return

Dashboard.$inject = [
  '$scope'
  '$filter'
  'ngToast'
]

angular.module('app.dashboard').controller 'Dashboard', Dashboard
