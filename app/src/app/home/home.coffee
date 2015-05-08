angular.module( 'app.home', [
  'ui.router'
  'flipList'
])

.config ($stateProvider) ->
  $stateProvider.state 'home',
    url: '/'
    controller: 'HomeCtrl'
    templateUrl: 'home/home.tpl.html'

.controller 'HomeCtrl', ($scope, flipList) ->
  s = $scope
  s.test = "They're back..."
  s.users = flipList(
    collection: 'users'
  )
  s.users.$get()
  s.users.$setActive()
  
  s.refresh = -> console.log s.users; s.users.$get()
