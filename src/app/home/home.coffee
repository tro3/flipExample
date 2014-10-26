angular.module( 'app.home', [
  'ui.router',
  'ui.bootstrap',
  'app.userform',
  'app.groupform',
  'flipComponents'
])

 #* Each section or module of the site can also have its own routes. AngularJS
 #* will handle ensuring they are all available at run-time, but splitting it
 #* this way makes each module more "self-contained".

.config(($stateProvider) ->
  $stateProvider.state('home',
    url: '/home'
    views:
      main:
        controller: 'homeCtrl'
        templateUrl: 'home/home.tpl.html'
    data:
      pageTitle: 'Home'
  )
)


.controller( 'homeCtrl', ($scope, $q, flipList, flipDoc) ->
  s = $scope


  # Base scope variables

  s.usergroups = flipList(
    collection: 'usergroups'
  )
    
  s.users = flipList(
    collection: 'users'
  )
  
  s.currentGroupId = null
  s.bufferGroup = null
  s.groupChoices = []

  s.selectedUserId = null
  s.bufferUser = null
  s.addedUser = null

  s.displayUsers = []
  

  
  # List updates

  updateUsergroups = ->
    s.usergroups.$get()
    .then( ->
      s.groupChoices = [{title: "All Users", _id:null}]
      for item in s.usergroups
        s.groupChoices.push(
          title: item.title
          _id: item._id
        )
    )

  updateUsers = ->
    s.users.$get()

  updateData = ->
    q1 = updateUsergroups()
    q2 = updateUsers()
    $q.all([q1,q2]).then( ->
      updateDisplay()
    )

  updateDisplay = ->
    if s.currentGroupId
      grp = idLookup(s.usergroups, s.currentGroupId)
      if not grp or angular.isUndefined(grp.users)
        s.displayUsers = []
      else
        fcn = (x) ->
          idLookup(grp.users, x._id)
        s.displayUsers = s.users.filter(fcn)
    else
      s.displayUsers = s.users
  
  
    
  # Utility
  
  idLookup = (list, id) ->
    for item in list
      if id == item._id
        return item
    null

  idList = (list) ->
    ids = []
    for item in list
      ids.push(item._id)
    ids



  # Group event handling
  
  s.$watch('currentGroupId', ->
    s.bufferGroup = null
    s.bufferUser = null
    s.selectedUserId = null
    updateDisplay()
  )
  
  s.onGroupNew = ->
    s.bufferGroup = flipDoc('usergroups', {users:[]})

  s.onGroupEdit = ->
    s.bufferGroup = flipDoc(idLookup(s.usergroups, s.currentGroupId))

  s.onGroupDelete = ->
    grp = idLookup(s.usergroups, s.currentGroupId)
    grp.$delete()
    .then( ->
      s.currentGroupId = null
      s.bufferGroup = null
      updateUsergroups()
    )
    
  s.onGroupSave = ->
    updateUsergroups()
    .then( ->
      s.currentGroupId = s.bufferGroup._id
      s.bufferGroup = null
    )

  s.onGroupCancel = ->
    s.bufferGroup = null



  # User Event Handling

  s.$watch('selectedUserId', ->
    if s.selectedUserId
      s.bufferUser = flipDoc(idLookup(s.users, s.selectedUserId))
    else
      s.bufferUser = null
  )

  s.onUserSelect = (id) ->
    if id == s.selectedUserId
      s.selectedUserId = null
    else
      s.selectedUserId = id

  $scope.onUserNew = () ->
    $scope.selectedUserId = null
    $scope.bufferUser = flipDoc('users')

  $scope.onUserCancel = () ->
    $scope.selectedUserId = null
    $scope.bufferUser = null

  $scope.onUserDelete = () ->
    $scope.bufferUser.$delete()
    .then( () ->
      $scope.selectedUserId = null
      $scope.bufferUser = null
      updateData()
    )
  
  $scope.onUserSave = () ->
    $scope.users.$get()
    .then( () ->
      $scope.selectedUserId = $scope.bufferUser._id
    )

  s.onUserAdd = ->
    grp = idLookup(s.usergroups, s.currentGroupId)
    grp.users.push(s.addedUser)
    grp.$save()
    .then( ->
      s.selectedUserId = s.addedUser._id
      s.addedUser = null
      updateDisplay()
    )

  s.onUserRemove = ->
    grp = idLookup(s.usergroups, s.currentGroupId)
    grp_ids = idList(grp)
    grp.users.splice(grp_ids.indexOf(s.selectedUserId), 1)
    grp.$save()
    .then( ->
      s.addedUser = null
      s.selectedUserId = null
      updateDisplay()
    )



  # Initialization
  
  updateData()

)


