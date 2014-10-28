angular.module('app.userform', ['flipComponents', 'userform/userform.tpl.html']).directive('userForm', function() {
  return {
    scope: {
      item: '='
    },
    templateUrl: 'userform/userform.tpl.html',
    controller: 'userFormController'
  };
}).controller('userFormController', function($scope, $attrs, $parse) {
  var onCancelInvoker, onSaveInvoker;
  onSaveInvoker = $attrs.onSave ? $parse($attrs.onSave) : angular.noop;
  onCancelInvoker = $attrs.onCancel ? $parse($attrs.onCancel) : angular.noop;
  $scope.disabled = function() {
    return $scope.item === null;
  };
  $scope.save = function() {
    return $scope.item.$save().then(function() {
      return onSaveInvoker($scope.$parent);
    });
  };
  return $scope.cancel = function() {
    return onCancelInvoker($scope.$parent);
  };
});
