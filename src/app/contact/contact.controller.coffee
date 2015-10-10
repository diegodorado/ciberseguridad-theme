### @ngInject ###
Contact = ($scope, $stateParams, dataservice) ->

  $scope.submit = () ->
    #todo: actually send and email
    if $scope.contactForm.$valid
      dataservice.submitContact($scope.data).then (response) ->
        console.log response
      console.log $scope.data

  $scope.data =
    name: ''
    email: ''
    query: ''

  return

angular.module('app.contact').controller 'Contact', Contact
Contact.$inject = [
  '$scope'
  '$stateParams'
  'dataservice'
]
