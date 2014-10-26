
angular.module( 'app.groupform', [
  'flipComponents',
  'groupform/groupform.tpl.html',
])

.directive('groupForm', () ->
  scope:
    item: '='
  templateUrl: 'groupform/groupform.tpl.html'
  controller: 'groupFormController'
)

.controller('groupFormController', ($scope, $attrs, $parse) ->

  onSaveInvoker = if $attrs.onSave then $parse($attrs.onSave) else angular.noop
  onCancelInvoker = if $attrs.onCancel            \
                    then $parse($attrs.onCancel)  \
                    else angular.noop
  
  $scope.disabled = () ->
    $scope.item == null

  $scope.save = () ->
    $scope.item.$save()
    .then( () -> onSaveInvoker($scope.$parent) )

  $scope.cancel = () ->
    onCancelInvoker($scope.$parent)

)
