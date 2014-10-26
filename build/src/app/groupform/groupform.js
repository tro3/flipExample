angular.module('app.groupform', ['flipComponents', 'groupform/groupform.tpl.html']).directive('groupForm', function() {
  return {
    scope: {
      item: '='
    },
    templateUrl: 'groupform/groupform.tpl.html',
    controller: 'groupFormController'
  };
}).controller('groupFormController', function($scope, $attrs, $parse) {
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
