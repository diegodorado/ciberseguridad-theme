### @ngInject ###
Contact = ($scope, $stateParams) ->

  $scope.submit = () ->
    #todo: actually send and email
    if $scope.contactForm.$valid
      console.log $scope.data

  $scope.data =
    name: ''
    email: ''
    query: ''

  console.log 'contact'
  return

angular.module('app.contact').controller 'Contact', Contact
Contact.$inject = [
  '$scope'
  '$stateParams'
]
