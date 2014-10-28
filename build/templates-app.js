angular.module('templates-app', ['groupform/groupform.tpl.html', 'home/home.tpl.html', 'userform/userform.tpl.html']);

angular.module("groupform/groupform.tpl.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("groupform/groupform.tpl.html",
    "<form class=\"form-horizontal\" role=\"form\">\n" +
    "    <div class=\"form-group\">\n" +
    "        <label for=\"name\" class=\"col-sm-4 control-label\">Groupname</label>\n" +
    "        <div class=\"col-sm-8\">\n" +
    "            <input ng-disabled=\"disabled()\" class=\"form-control\" id=\"name\" ng-model=\"item.name\"/>\n" +
    "        </div>\n" +
    "    </div>\n" +
    "    <div class=\"form-group\">\n" +
    "        <label for=\"title\" class=\"col-sm-4 control-label\">Display Name</label>\n" +
    "        <div class=\"col-sm-8\">\n" +
    "            <input ng-disabled=\"disabled()\" class=\"form-control\" id=\"title\" ng-model=\"item.title\"/>\n" +
    "        </div>\n" +
    "    </div>\n" +
    "    <div class=\"form-group\">\n" +
    "        <div class=\"col-sm-offset-4 col-sm-8\">\n" +
    "            <button ng-disabled=\"disabled()\" type=\"submit\" class=\"btn btn-default\" ng-click=\"save()\">Save</button>\n" +
    "            <button ng-disabled=\"disabled()\" type=\"submit\" class=\"btn btn-default\" ng-click=\"cancel()\">Cancel</button>\n" +
    "        </div>\n" +
    "    </div>\n" +
    "</form>");
}]);

angular.module("home/home.tpl.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("home/home.tpl.html",
    "\n" +
    "<div class=\"container\">\n" +
    "	<div class=\"row clearfix\">\n" +
    "		<div class=\"col-md-12 column\">\n" +
    "			<div class=\"page-header\">\n" +
    "				<h1>\n" +
    "					User List\n" +
    "				</h1>\n" +
    "                                <br/>\n" +
    "                                <div class=\"row clearfix\" id=\"groups\">\n" +
    "                                        <div class=\"col-md-4 column\">\n" +
    "                                                <form class=\"form-horizontal\" role=\"form\">\n" +
    "                                                        <div class=\"form-group\">\n" +
    "                                                            <label for=\"last_name\" class=\"col-sm-4 control-label\">Usergroup</label>\n" +
    "                                                            <div class=\"col-sm-8\">\n" +
    "                                                              <select class=\"form-control\" ng-options=\"x._id as x.title for x in groupChoices\"\n" +
    "                                                                      ng-model=\"currentGroupId\"></select>\n" +
    "                                                            </div>\n" +
    "                                                        </div>\n" +
    "                                                </form>                                          \n" +
    "                                        </div>\n" +
    "                                        <div class=\"col-md-4 column\">\n" +
    "                                              <label class=\"control-label\">Group actions</label>&nbsp;&nbsp;\n" +
    "                                              <div class=\"btn-group\" id=\"groupActions\">\n" +
    "                                                  <button class=\"btn btn-default\" ng-click=\"onGroupNew()\">New</button>\n" +
    "                                                  <button class=\"btn btn-default\" ng-click=\"onGroupEdit()\"   ng-disabled=\"!currentGroupId\">Edit</button>\n" +
    "                                                  <button class=\"btn btn-default\" ng-click=\"onGroupDelete()\" ng-disabled=\"!currentGroupId\">Delete</button>\n" +
    "                                              </div>\n" +
    "                                        </div>\n" +
    "                                        <div class=\"col-md-4 column\" ng-show=\"bufferGroup\">\n" +
    "                                              <div group-form id=\"groupForm\"\n" +
    "                                                   item=\"bufferGroup\"\n" +
    "                                                   on-save=\"onGroupSave()\"\n" +
    "                                                   on-cancel=\"onGroupCancel()\"\n" +
    "                                              ></div>\n" +
    "                                        </div>\n" +
    "                                </div>\n" +
    "			</div>\n" +
    "		</div>\n" +
    "	</div>\n" +
    "	<div class=\"row clearfix\">\n" +
    "		<div class=\"col-md-8 column\">\n" +
    "                        <div class=\"row\" ng-show=\"!currentGroupId\">\n" +
    "                              <div class=\"col-md-6 column\" id=\"userActions\">\n" +
    "                                    <label class=\"control-label\">User actions</label>&nbsp;&nbsp;\n" +
    "                                    <div class=\"btn-group\">\n" +
    "                                            <button class=\"btn btn-default\" type=\"button\" ng-click=\"onUserNew()\">\n" +
    "                                              <em class=\"glyphicon glyphicon-align-left\"></em> New\n" +
    "                                            </button>\n" +
    "                                            <button class=\"btn btn-default\" type=\"button\" ng-click=\"onUserDelete()\" ng-disabled=\"!selectedUserId\">\n" +
    "                                              <em class=\"glyphicon glyphicon-align-center\"></em> Delete\n" +
    "                                            </button>\n" +
    "                                    </div>                          \n" +
    "                              </div>\n" +
    "                        </div>\n" +
    "			<div class=\"row\" ng-show=\"currentGroupId\">\n" +
    "                                <div class=\"col-md-6 column\">\n" +
    "                                      <form class=\"form-horizontal\" role=\"form\">\n" +
    "                                            <div class=\"form-group\">\n" +
    "                                                <label for=\"addusername\" class=\"col-sm-4 control-label\">User</label>\n" +
    "                                                <div class=\"col-sm-8\">\n" +
    "                                                    <div class=\"input-group\" id=\"userAdd\">\n" +
    "                                                      <input class=\"form-control\" id=\"addusername\" ng-model=\"addedUser\"\n" +
    "                                                             typeahead=\"x as x.full_name for x in users | filter:{full_name:$viewValue}\"/>\n" +
    "                                                      <span class=\"input-group-btn\">\n" +
    "                                                        <button class=\"btn btn-default\" type=\"button\" ng-click=\"onUserAdd()\">\n" +
    "                                                          <em class=\"glyphicon glyphicon-align-left\"></em> Add\n" +
    "                                                        </button>\n" +
    "                                                      </span>\n" +
    "                                                    </div>\n" +
    "                                                </div>\n" +
    "                                            </div>\n" +
    "                                      </form>\n" +
    "                                </div>\n" +
    "                                <div class=\"col-md-6 column\">                                      \n" +
    "                                      <button class=\"btn btn-default\" type=\"button\" ng-click=\"onUserRemove()\" ng-disabled=\"!selectedUserId\">\n" +
    "                                        <em class=\"glyphicon glyphicon-align-center\"></em>Remove\n" +
    "                                      </button>\n" +
    "                                </div>\n" +
    "			</div>\n" +
    "                        <br/>\n" +
    "                        <br/>\n" +
    "                        <div flip-table title=\"Users\" id=\"users\"\n" +
    "                            list=\"displayUsers\"\n" +
    "                            columns=\"[\n" +
    "                                {title:'Username',    attr:'username'  },\n" +
    "                                {title:'Full Name',   attr:'full_name'  },\n" +
    "                                {title:'Staff',       attr:'staff'  },\n" +
    "                                {title:'Superuser',   attr:'superuser'},\n" +
    "                            ]\"\n" +
    "                            selected-id=\"selectedUserId\"\n" +
    "                            init-sort=\"username\"\n" +
    "                        ></div>\n" +
    "		</div>\n" +
    "		<div class=\"col-md-4 column\">\n" +
    "                  <div user-form id=\"userForm\" item=\"bufferUser\" on-save=\"onUserSave()\" on-cancel=\"onUserCancel()\"></div>\n" +
    "                  <div adduser-form></div>\n" +
    "		</div>\n" +
    "	</div>\n" +
    "</div>             ");
}]);

angular.module("userform/userform.tpl.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("userform/userform.tpl.html",
    "<form class=\"form-horizontal\" role=\"form\">\n" +
    "    <div class=\"form-group\">\n" +
    "        <label for=\"username\" class=\"col-sm-4 control-label\">Username</label>\n" +
    "        <div class=\"col-sm-8\">\n" +
    "            <input ng-disabled=\"disabled()\" class=\"form-control\" id=\"username\" ng-model=\"item.username\"/>\n" +
    "        </div>\n" +
    "    </div>\n" +
    "    <div class=\"form-group\">\n" +
    "        <label for=\"first_name\" class=\"col-sm-4 control-label\">First_name</label>\n" +
    "        <div class=\"col-sm-8\">\n" +
    "            <input ng-disabled=\"disabled()\" class=\"form-control\" id=\"first_name\" ng-model=\"item.first_name\"/>\n" +
    "        </div>\n" +
    "    </div>\n" +
    "    <div class=\"form-group\">\n" +
    "        <label for=\"last_name\" class=\"col-sm-4 control-label\">Last_name</label>\n" +
    "        <div class=\"col-sm-8\">\n" +
    "            <input ng-disabled=\"disabled()\" class=\"form-control\" id=\"last_name\" ng-model=\"item.last_name\"/>\n" +
    "        </div>\n" +
    "    </div>\n" +
    "    <div class=\"form-group\">\n" +
    "        <label for=\"superuser\" class=\"col-sm-4 control-label\">Superuser</label>\n" +
    "        <div class=\"col-sm-8\">\n" +
    "            <div class=\"checkbox\">\n" +
    "                <input ng-disabled=\"disabled()\" type=\"checkbox\" id=\"superuser\" ng-model=\"item.superuser\"/>\n" +
    "            </div>\n" +
    "        </div>\n" +
    "    </div>\n" +
    "    <div class=\"form-group\">\n" +
    "        <label for=\"staff\" class=\"col-sm-4 control-label\">Staff</label>\n" +
    "        <div class=\"col-sm-8\">\n" +
    "            <div class=\"checkbox\">\n" +
    "                <input ng-disabled=\"disabled()\" type=\"checkbox\" id=\"staff\" ng-model=\"item.staff\"/>\n" +
    "            </div>\n" +
    "        </div>\n" +
    "    </div>\n" +
    "    <div class=\"form-group\">\n" +
    "        <div class=\"col-sm-offset-4 col-sm-8\">\n" +
    "            <button ng-disabled=\"disabled()\" type=\"submit\" class=\"btn btn-default\" ng-click=\"save()\">Save</button>\n" +
    "            <button ng-disabled=\"disabled()\" type=\"submit\" class=\"btn btn-default\" ng-click=\"cancel()\">Cancel</button>\n" +
    "        </div>\n" +
    "    </div>\n" +
    "</form>");
}]);
