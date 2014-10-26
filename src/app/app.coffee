angular.module( 'appTop', [
  'templates-app',
  'templates-common',
  'app.home',
  'app.userform',
  'app.groupform',
  'ui.router'
])

.config( ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise( '/home' )
)

.run( () ->
)

.controller('appCtrl', ($scope, $location) ->
  $scope.$on('$stateChangeSuccess', (event, toState, toParams,
                                     fromState, fromParams) ->
    if angular.isDefined(toState.data.pageTitle)
      $scope.pageTitle = toState.data.pageTitle + ' | ngBoilerplate'
  )
)
