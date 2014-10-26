angular.module('app.userform', ['flipComponents', 'userform/userform.tpl.html']).directive('userForm', function() {
  return {
    scope: {
      item: '='
    },
    templateUrl: 'userform/userform.tpl.html',
    controller: 'userFormController'
  };
}).controller('userFormController', function($scope, $attrs, $parse) {
  var onSaveInvoker;
  onSaveInvoker = $attrs.onSave ? $parse($attrs.onSave) : angular.noop;
  $scope.disabled = function() {
    return $scope.item === null;
  };
  return $scope.save = function() {
    return $scope.item.$save().then(function() {
      return onSaveInvoker($scope.$parent);
    });
  };
});
