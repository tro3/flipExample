
angular.module( 'app.userform', [
  'flipComponents',
  'userform/userform.tpl.html',
])

.directive('userForm', () ->
  scope:
    item: '='
  templateUrl: 'userform/userform.tpl.html'
  controller: 'userFormController'
)

.controller('userFormController', ($scope, $attrs, $parse) ->

  onSaveInvoker = if $attrs.onSave then $parse($attrs.onSave) else angular.noop
  
  $scope.disabled = () ->
    $scope.item == null

  $scope.save = () ->
    $scope.item.$save()
    .then( () -> onSaveInvoker($scope.$parent) )

)
