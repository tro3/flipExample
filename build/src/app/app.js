angular.module('appTop', ['templates-app', 'templates-common', 'app.home', 'app.userform', 'app.groupform', 'ui.router']).config(function($stateProvider, $urlRouterProvider) {
  return $urlRouterProvider.otherwise('/home');
}).run(function() {}).controller('appCtrl', function($scope, $location) {
  return $scope.$on('$stateChangeSuccess', function(event, toState, toParams, fromState, fromParams) {
    if (angular.isDefined(toState.data.pageTitle)) {
      return $scope.pageTitle = toState.data.pageTitle + ' | ngBoilerplate';
    }
  });
});
