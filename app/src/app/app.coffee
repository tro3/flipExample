angular.module( 'appTop', [
  'templates'
  'app.home'
  'app.about'
  'flipCache'
  'ui.router'
])

.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise('/')


#.run () ->


.controller 'appCtrl', ($scope, flipCache) ->
  $scope.$on '$stateChangeStart', ->
    flipCache.clearActives()
  
