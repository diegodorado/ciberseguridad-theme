### @ngInject ###
Contact = ($scope, $window, dataservice, ngToast, $filter) ->

  reset = ->
    $scope.submissionAttempted = false
    $scope.data =
      name: ''
      email: ''
      query: ''

  reset()
  $scope.back = () ->
    $window.history.back()

  $scope.submit = () ->
    $scope.submissionAttempted = true
    #todo: actually send and email
    if $scope.contactForm.$valid
      dataservice.submitContact($scope.data).then (response) ->
        ngToast.create  $filter('translate')('mensaje.enviado.correctamente')
        reset()

  return

angular.module('app.contact').controller 'Contact', Contact
Contact.$inject = [
  '$scope'
  '$window'
  'dataservice'
  'ngToast'
  '$filter'
]
