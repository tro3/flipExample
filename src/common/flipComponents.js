(function() {
  angular.module('flipComponents', ['ui.bootstrap', 'flip_helpers', 'flip_resource', 'flip_table']);

}).call(this);

(function() {
  angular.module('flip_helpers', []).filter('flipDisplay', function($filter) {
    return function(item, col) {
      var digits;
      if (angular.isUndefined(item[col.attr]) || item[col.attr] === null) {
        return '';
      }
      if (angular.isUndefined(col.format)) {
        return item[col.attr];
      }
      if (col.format === 'date') {
        return $filter('date')(item[col.attr], "MM/dd/yyyy");
      }
      if (col.format === 'number') {
        digits = angular.isDefined(col.digits) ? col.digits : void 0;
        return $filter('number')(item[col.attr], digits);
      }
    };
  });

}).call(this);

(function() {
  var __hasProp = {}.hasOwnProperty;

  angular.module('flip_resource', []).factory('flipDoc', function($http, $q) {
    var FlipDoc;
    FlipDoc = (function() {
      function FlipDoc(first, second) {
        this._id = null;
        if (typeof first === 'object') {
          this._extend(first);
        } else {
          this._collection = first;
          if (typeof second === 'object') {
            this._extend(second);
          } else {
            this._id = second;
          }
        }
      }

      FlipDoc.prototype._extend = function(data) {
        var key, val, _results;
        _results = [];
        for (key in data) {
          val = data[key];
          if (!angular.isFunction(val)) {
            _results.push(this[key] = val);
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      };

      FlipDoc.prototype._clear = function() {
        var key, val, _results;
        _results = [];
        for (key in this) {
          val = this[key];
          if (!angular.isFunction(val)) {
            _results.push(this[key] = null);
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      };

      FlipDoc.prototype.$get = function() {
        var defer;
        defer = $q.defer();
        if (!angular.isDefined(this._id)) {
          return $q.reject();
        }
        $http({
          method: 'GET',
          url: '/api/' + this._collection + '/' + this._id
        }).success((function(_this) {
          return function(data, status, headers, config) {
            if (angular.isDefined(data._status) && data._status === 'OK' && angular.isDefined(data._item)) {
              _this._extend(data._item);
              return defer.resolve();
            } else {
              return defer.reject(data);
            }
          };
        })(this)).error((function(_this) {
          return function(data, status, headers, config) {
            return defer.reject({
              _status: "ERR",
              _msg: "Server returned code " + status
            });
          };
        })(this));
        return defer.promise;
      };

      FlipDoc.prototype.$save = function() {
        var data, defer, key, val;
        data = {};
        for (key in this) {
          if (!__hasProp.call(this, key)) {continue;}
          val = this[key];
          if (!angular.isFunction(val)) {
            data[key] = val;
          }
        }
        defer = $q.defer();
        $http({
          method: this._id ? 'PUT' : 'POST',
          url: this._id ? "/api/" + this._collection + "/" + this._id : "/api/" + this._collection,
          data: data
        }).success((function(_this) {
          return function(data, status, headers, config) {
            if (angular.isDefined(data._status) && data._status === 'OK' && angular.isDefined(data._item)) {
              _this._extend(data._item);
              return defer.resolve();
            } else {
              return defer.reject(data);
            }
          };
        })(this)).error((function(_this) {
          return function(data, status, headers, config) {
            return defer.reject({
              _status: "ERR",
              _msg: "Server returned code " + status
            });
          };
        })(this));
        return defer.promise;
      };

      FlipDoc.prototype.$delete = function() {
        var defer;
        if (!angular.isDefined(this._id)) {
          this._clear();
          return $q.when();
        }
        defer = $q.defer();
        $http({
          method: 'DELETE',
          url: "/api/" + this._collection + "/" + this._id
        }).success((function(_this) {
          return function(data, status, headers, config) {
            if (status === 204) {
              _this._clear();
              return defer.resolve();
            } else {
              return defer.reject(data);
            }
          };
        })(this)).error((function(_this) {
          return function(data, status, headers, config) {
            return defer.reject({
              _status: "ERR",
              _msg: "Server returned code " + status
            });
          };
        })(this));
        return defer.promise;
      };

      return FlipDoc;

    })();
    return function(coll, id) {
      return new FlipDoc(coll, id);
    };
  }).factory('flipList', function($http, $q, flipDoc) {
    return function(config) {
      var flipList;
      flipList = [];
      flipList.config = config;
      flipList.get_url = function() {
        var q, url;
        url = "/api/" + flipList.config.collection;
        q = false;
        if (angular.isDefined(flipList.config.filter)) {
          url += q ? '&' : '?';
          url += "q=" + (JSON.stringify(flipList.config.filter));
          q = true;
        }
        if (angular.isDefined(flipList.config.fields)) {
          url += q ? '&' : '?';
          url += "fields=" + (JSON.stringify(flipList.config.fields));
          q = true;
        }
        if (angular.isDefined(flipList.config.max_count)) {
          url += q ? '&' : '?';
          url += "max_count=" + (JSON.stringify(flipList.config.max_count));
          q = true;
        }
        if (angular.isDefined(flipList.config.page)) {
          url += q ? '&' : '?';
          url += "page=" + (JSON.stringify(flipList.config.page));
          q = true;
        }
        return url;
      };
      flipList.$get = function() {
        var defer;
        defer = $q.defer();
        $http({
          method: 'GET',
          url: flipList.get_url()
        }).success((function(_this) {
          return function(data, status, headers, config) {
            var x, _i, _len, _ref;
            if (angular.isDefined(data._status) && data._status === 'OK' && angular.isDefined(data._items)) {
              flipList.splice(0, flipList.length);
              flipList._auth = data._auth;
              _ref = data._items;
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                x = _ref[_i];
                flipList.push(flipDoc(flipList.config.collection, x));
              }
              if (angular.isDefined(flipList.config.on_get)) {
                flipList.config.on_get(flipList);
              }
              return defer.resolve();
            } else {
              return defer.reject(data);
            }
          };
        })(this)).error((function(_this) {
          return function(data, status, headers, config) {
            return defer.reject({
              _status: "ERR",
              _msg: "Server returned code " + status
            });
          };
        })(this));
        return defer.promise;
      };
      flipList.$add = function(data) {
        var defer;
        defer = $q.defer();
        data = flipDoc(config.collection, data);
        data.$save().then(function() {
          return flipList.$get();
        }).then(function() {
          return defer.resolve();
        })["catch"](function(err) {
          return defer.reject(err);
        });
        return defer.promise;
      };
      flipList.$delete = function(data) {
        var defer, inst, x;
        if (typeof data === 'object') {
          data = data._id;
        }
        inst = ((function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = flipList.length; _i < _len; _i++) {
            x = flipList[_i];
            if (x._id === data) {
              _results.push(x);
            }
          }
          return _results;
        })())[0];
        defer = $q.defer();
        inst.$delete().then(function() {
          return flipList.$get();
        }).then(function() {
          return defer.resolve();
        })["catch"](function(err) {
          return defer.reject(err);
        });
        return defer.promise;
      };
      return flipList;
    };
  });

}).call(this);

(function() {
  angular.module('flip_table', ['flip_helpers']).directive('flipTable', function() {
    return {
      scope: {
        list: '=',
        selected: '=?',
        selectedIndex: '=?',
        selectedId: '=?'
      },
      templateUrl: 'template/flipTable.html',
      controller: 'flipTableController'
    };
  }).controller('flipTableController', function($scope, $attrs, $parse) {
    var onSelectInvoker, selecting, update_selected;
    $scope.columns = $parse($attrs.columns)($scope);
    if (angular.isDefined($attrs.initSort)) {
      $scope.sort = $attrs.initSort;
    }
    if (angular.isDefined($attrs.initReverse)) {
      $scope.reverse = $attrs.initReverse;
    }
    $scope.headers = $attrs.headers ? $parse($attrs.headers)($scope.$parent) : true;
    $scope.filters = {};
    onSelectInvoker = $attrs.onSelect ? $parse($attrs.onSelect) : angular.noop;
    $scope.sort_click = function(col) {
      if (col.attr === $scope.sort) {
        return $scope.reverse = !$scope.reverse;
      } else {
        $scope.sort = col.attr;
        return $scope.reverse = false;
      }
    };
    $scope.selected = null;
    $scope.select_click = function(item) {
      if (item === $scope.selected) {
        return $scope.selected = null;
      } else {
        return $scope.selected = item;
      }
    };
    selecting = [false, false, false];
    $scope.$watch('selected', function() {
      if (selecting[0]) {
        return selecting[0] = false;
      } else {
        selecting = [false, true, true];
        return update_selected($scope.selected);
      }
    });
    $scope.$watch('selectedIndex', function() {
      if (selecting[1]) {
        return selecting[1] = false;
      } else {
        selecting = [true, false, true];
        return update_selected($scope.list[$scope.selectedIndex]);
      }
    });
    $scope.$watch('selectedId', function() {
      var item, _i, _len, _ref;
      if (!$scope.selectedId) {
        return update_selected(null);
      }
      if (selecting[2]) {
        return selecting[2] = false;
      } else {
        selecting = [true, true, false];
        _ref = $scope.list;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          if (item._id === $scope.selectedId) {
            update_selected(item);
            return;
          }
        }
        return update_selected(null);
      }
    });
    $scope.listkeys = function() {
      var item, result, _i, _len, _ref;
      result = '';
      _ref = $scope.list;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        result += item.$$hashKey;
      }
      return result;
    };
    $scope.$watch('listkeys()', function() {
      var item, _i, _len, _ref;
      if ($scope.selectedId) {
        selecting = [true, true, true];
        _ref = $scope.list;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          if (item._id === $scope.selectedId) {
            $scope.selected = item;
            return;
          }
        }
        return $scope.selected = null;
      }
    });
    return update_selected = function(item) {
      if (angular.isDefined(item) && item !== null) {
        $scope.selected = item;
        $scope.selectedIndex = $scope.list.indexOf(item);
        $scope.selectedId = item._id;
      } else {
        $scope.selected = null;
        $scope.selectedIndex = null;
        $scope.selectedId = null;
      }
      return onSelectInvoker($scope.$parent, {
        item: item
      });
    };
  }).run(function($templateCache) {
    return $templateCache.put("template/flipTable.html", "<table class=\"table table-hover\">\n    <thead ng-if=\"headers\">\n    <tr>\n        <th ng-repeat=\"col in columns\" ng-style=\"col.width ? {width: col.width} : {}\">\n            <div>\n                <span ng-click=\"$parent.sort_click(col)\">\n                    {{col.title}}\n                    <span class=\"glyphicon glyphicon-chevron-up\" ng-show=\"sort == col.attr && !reverse\"></span>\n                    <span class=\"glyphicon glyphicon-chevron-down\" ng-show=\"sort == col.attr && reverse\"></span>\n                </span>\n                <span class=\"glyphicon glyphicon-search\" ng-click=\"visible=!visible\"></span>\n            </div>\n            <div collapse=\"!visible\">\n                <input class=\"form-control\" ng-model=\"$parent.filters[col.attr]\" style=\"font-weight: normal\"></input>\n            </div>\n        </th>\n    </tr>\n    </thead>\n    <tbody>\n        <tr ng-repeat=\"item in list | filter:filters | orderBy:sort:reverse\"\n          ng-click=\"$parent.select_click(item)\"\n          ng-class=\"{'info': $parent.selected == item}\"\n          ng-style=\"col.width ? {width: col.width} : {}\"\n        >\n            <td ng-repeat=\"col in columns\">\n                <a ng-if=\"col.url_attr\" href=\"{{ item[col.url_attr] }}\">{{ item | flipDisplay:col }}</a>\n                <span ng-if=\"!col.url_attr\">{{ item | flipDisplay:col }}</span>\n            </td>\n        </tr>\n    </tbody>\n</table>        ");
  });

}).call(this);
