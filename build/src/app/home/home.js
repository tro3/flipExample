angular.module('app.home', ['ui.router', 'ui.bootstrap', 'app.userform', 'app.groupform', 'flipComponents']).config(function($stateProvider) {
  return $stateProvider.state('home', {
    url: '/home',
    views: {
      main: {
        controller: 'homeCtrl',
        templateUrl: 'home/home.tpl.html'
      }
    },
    data: {
      pageTitle: 'Home'
    }
  });
}).controller('homeCtrl', function($scope, $q, flipList, flipDoc) {
  var idList, idLookup, newstate, s, updateData, updateDisplay, updateUsergroups, updateUsers;
  s = $scope;
  s.usergroups = flipList({
    collection: 'usergroups'
  });
  s.users = flipList({
    collection: 'users'
  });
  s.currentGroupId = null;
  s.bufferGroup = null;
  s.groupChoices = [];
  s.selectedUserId = null;
  s.bufferUser = null;
  s.addedUser = null;
  s.displayUsers = [];
  updateUsergroups = function() {
    return s.usergroups.$get().then(function() {
      var item, _i, _len, _ref, _results;
      s.groupChoices = [
        {
          title: "All Users",
          _id: null
        }
      ];
      _ref = s.usergroups;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        _results.push(s.groupChoices.push({
          title: item.title,
          _id: item._id
        }));
      }
      return _results;
    });
  };
  updateUsers = function() {
    return s.users.$get();
  };
  updateData = function() {
    var q1, q2;
    q1 = updateUsergroups();
    q2 = updateUsers();
    return $q.all([q1, q2]).then(function() {
      return updateDisplay();
    });
  };
  updateDisplay = function() {
    var fcn, grp;
    if (s.currentGroupId) {
      grp = idLookup(s.usergroups, s.currentGroupId);
      if (!grp || angular.isUndefined(grp.users)) {
        return s.displayUsers = [];
      } else {
        fcn = function(x) {
          return idLookup(grp.users, x._id);
        };
        return s.displayUsers = s.users.filter(fcn);
      }
    } else {
      return s.displayUsers = s.users;
    }
  };
  idLookup = function(list, id) {
    var item, _i, _len;
    for (_i = 0, _len = list.length; _i < _len; _i++) {
      item = list[_i];
      if (id === item._id) {
        return item;
      }
    }
    return null;
  };
  idList = function(list) {
    var ids, item, _i, _len;
    ids = [];
    for (_i = 0, _len = list.length; _i < _len; _i++) {
      item = list[_i];
      ids.push(item._id);
    }
    return ids;
  };
  s.$watch('currentGroupId', function() {
    s.bufferGroup = null;
    s.bufferUser = null;
    s.selectedUserId = null;
    return updateDisplay();
  });
  s.onGroupNew = function() {
    return s.bufferGroup = flipDoc('usergroups', {
      users: []
    });
  };
  s.onGroupEdit = function() {
    return s.bufferGroup = flipDoc(idLookup(s.usergroups, s.currentGroupId));
  };
  s.onGroupDelete = function() {
    var grp;
    grp = idLookup(s.usergroups, s.currentGroupId);
    return grp.$delete().then(function() {
      s.currentGroupId = null;
      s.bufferGroup = null;
      return updateUsergroups();
    });
  };
  s.onGroupSave = function() {
    return updateUsergroups().then(function() {
      s.currentGroupId = s.bufferGroup._id;
      return s.bufferGroup = null;
    });
  };
  s.onGroupCancel = function() {
    return s.bufferGroup = null;
  };
  newstate = false;
  s.$watch('selectedUserId', function() {
    if (s.selectedUserId) {
      return s.bufferUser = flipDoc(idLookup(s.users, s.selectedUserId));
    } else if (newstate) {
      return newstate = false;
    } else {
      return s.bufferUser = null;
    }
  });
  $scope.onUserNew = function() {
    s.bufferUser = flipDoc('users');
    if ($scope.selectedUserId !== null) {
      newstate = true;
    }
    return $scope.selectedUserId = null;
  };
  $scope.onUserCancel = function() {
    $scope.selectedUserId = null;
    return s.bufferUser = null;
  };
  $scope.onUserDelete = function() {
    return $scope.bufferUser.$delete().then(function() {
      $scope.selectedUserId = null;
      return updateData();
    });
  };
  $scope.onUserSave = function() {
    return $scope.users.$get().then(function() {
      return $scope.selectedUserId = $scope.bufferUser._id;
    });
  };
  s.onUserAdd = function() {
    var grp;
    grp = idLookup(s.usergroups, s.currentGroupId);
    grp.users.push(s.addedUser);
    return grp.$save().then(function() {
      s.selectedUserId = s.addedUser._id;
      s.addedUser = null;
      return updateDisplay();
    });
  };
  s.onUserRemove = function() {
    var grp, grp_ids;
    grp = idLookup(s.usergroups, s.currentGroupId);
    grp_ids = idList(grp.users);
    grp.users.splice(grp_ids.indexOf(s.selectedUserId), 1);
    return grp.$save().then(function() {
      s.addedUser = null;
      s.selectedUserId = null;
      return updateDisplay();
    });
  };
  return updateData();
});
