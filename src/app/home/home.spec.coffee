 #* Tests sit right alongside the file they are testing, which is more intuitive
 #* and portable than separating `src` and `test` directories. Additionally, the
 #* build process will exclude all `.spec.js` files from the build
 #* automatically.


# Group States:
#    Selected group / No selected Group
#    Buffer group / no buffer group
#
#    Selected  Buffer  Transitions
#    No        No      Select, New
#    Yes       No      Select, Edit, Delete
#    No        Yes     (New) Select, Save, Cancel
#    Yes       Yes     (Edit) Select, Save, Cancel



# User States:
#    Selected group
#    Selected user
#    Buffer user
#
#    Sel Grp   Sel Usr  Buff Usr  Transitions
#    No        No       No        Select Grp, Select Usr, New
#    No        No       Yes       Select Grp, Select Usr, Save, Cancel
#    Yes       No       No        Select Grp, Select Usr, Add
#    Yes       No       Yes       N/A
#    No        Yes      Yes       Select Grp, Select Usr, Save, Cancel, Delete
#    Yes       Yes      Yes       Select Grp, Select Usr, Save, Cancel, Remove
#    No        Yes      No        N/A





describe( 'home controller,', () ->
  beforeEach(module('app.home'))
  beforeEach( inject( ($controller, $rootScope, _$httpBackend_,
                       $q, flipList, flipDoc) ->
    @httpBackend = _$httpBackend_
    @scope = $rootScope.$new()
    @ctrl = $controller('homeCtrl',
      $scope: @scope
      $q: $q
      flipList: flipList
      flipDoc: flipDoc
    )
    @httpBackend.expectGET('/api/usergroups').respond(200,
      _status: 'OK'
      _items: [{
        _id: 2
        name: "bedrock"
        title: "Bedrock"
        users: [{
          _id: 6
          username: "wwoman"
        }]
      }]
    )
    @httpBackend.expectGET('/api/users').respond(200,
      _status: 'OK'
      _items: [{
        _id: 4
        username: "brubble"
        },{
        _id: 5
        username: "fflint"
        },{
        _id: 6
        username: "wwoman"
        }]
    )
    @httpBackend.flush()
  ))


  describe( 'usergroup section', () ->
    it('should start with All Users, no buffer group,
        and proper group choices', () ->
      expect(@scope.currentGroupId).toBe(null)
      expect(@scope.bufferGroup).toBe(null)
      expect(@scope.groupChoices[0].title).toBe('All Users')
      expect(@scope.groupChoices[0]._id).toBe(null)
      expect(@scope.groupChoices[1].title).toBe('Bedrock')
      expect(@scope.groupChoices[1]._id).toBe(2)
    )

    it('should display only the user subset on Select Group', () ->
      @scope.currentGroupId = 2
      @scope.$digest()
      expect(@scope.displayUsers.length).toBe(1)
    )

    it('should add a blank buffer group on New', () ->
      @scope.onGroupNew()
      expect(@scope.bufferGroup).not.toBe(null)
      expect(@scope.bufferGroup.name).toBe(undefined)
    )

    it('should add a copy buffer group on Edit', () ->
      @scope.currentGroupId = 2
      @scope.onGroupEdit()
      expect(@scope.bufferGroup.name).toBe('bedrock')
    )

    it('should issue DELETE on Delete, remove buffer group and
        clear selected group', () ->
      @scope.currentGroupId = 2
      @scope.$digest()
      expect(@scope.displayUsers.length).toBe(1)
      @scope.onGroupDelete()
      @httpBackend.expectDELETE('/api/usergroups/2').respond(204)
      @httpBackend.expectGET('/api/usergroups').respond(200,
        _status: 'OK'
        _items: []
      )
      @httpBackend.flush()
      expect(@scope.currentGroupId).toBe(null)
      expect(@scope.bufferGroup).toBe(null)
      expect(@scope.displayUsers.length).toBe(3)
    )

    it('should reset buffer on Select after New', () ->
      @scope.onGroupNew()
      expect(@scope.bufferGroup).not.toBe(null)
      expect(@scope.bufferGroup.name).toBe(undefined)
      @scope.currentGroupId = 2
      @scope.$digest()
      expect(@scope.bufferGroup).toBe(null)
      expect(@scope.displayUsers.length).toBe(1)
    )

    it('should reset buffer on Cancel after New', () ->
      @scope.onGroupNew()
      expect(@scope.bufferGroup).not.toBe(null)
      expect(@scope.bufferGroup.name).toBe(undefined)
      @scope.onGroupCancel()
      expect(@scope.bufferGroup).toBe(null)
      expect(@scope.displayUsers.length).toBe(3)
    )

    it('should set selectedUserId to new item id,
       and clear buffer group on Save after New', () ->
      @scope.onGroupNew()
      expect(@scope.bufferGroup).not.toBe(null)
      @scope.bufferGroup.name = 'gotham'
      @scope.bufferGroup.title = 'Gotham'
      @scope.bufferGroup._id = 34
      @scope.onGroupSave()
      @httpBackend.expectGET('/api/usergroups').respond(200,
        _status: 'OK'
        _items: []
      )
      @httpBackend.flush()
      expect(@scope.bufferGroup).toBe(null)
      expect(@scope.currentGroupId).toBe(34)
      expect(@scope.displayUsers.length).toBe(0)
    )

    it('should reset buffer on Select after Edit', () ->
      @scope.currentGroupId = 2
      @scope.$digest()
      @scope.onGroupEdit()
      expect(@scope.bufferGroup).not.toBe(null)
      @scope.currentGroupId = null
      @scope.$digest()
      expect(@scope.bufferGroup).toBe(null)
      expect(@scope.displayUsers.length).toBe(3)
    )

    it('should reset buffer on Cancel after Edit', () ->
      @scope.currentGroupId = 2
      @scope.$digest()
      @scope.onGroupEdit()
      expect(@scope.bufferGroup).not.toBe(null)
      @scope.onGroupCancel()
      expect(@scope.bufferGroup).toBe(null)
      expect(@scope.displayUsers.length).toBe(1)
    )

    it('should clear buffer group on Save after Edit', () ->
      @scope.currentGroupId = 2
      @scope.$digest()
      @scope.onGroupEdit()
      @scope.onGroupSave()
      @httpBackend.expectGET('/api/usergroups').respond(200,
        _status: 'OK'
        _items: []
      )
      @httpBackend.flush()
      expect(@scope.bufferGroup).toBe(null)
      expect(@scope.currentGroupId).toBe(2)
      expect(@scope.displayUsers.length).toBe(1)
    )
  )

  describe('user section', () ->
    it('should start with no selection or buffer', () ->
      expect(@scope.currentGroupId).toBe(null)
      expect(@scope.bufferUser).toBe(null)
      expect(@scope.selectedUserId).toBe(null)
    )
    
    it('should start by displaying all users', () ->
      expect(@scope.displayUsers.length).toBe(3)
    )
    
    describe('with no user selected', () ->
      describe('with no group selected', () ->
        it('should create a blank buffer user on New', () ->
          @scope.onUserNew()
          expect(@scope.bufferUser).not.toBe(null)
        )
    
        it('should copy selection to the user buffer user
            on Select User', () ->
          @scope.onUserSelect(4)
          @scope.$digest()
          expect(@scope.bufferUser.username).toBe('brubble')
        )
    
        it('should blank the user buffer user on Cancel after New', () ->
          @scope.onUserNew()
          expect(@scope.bufferUser).not.toBe(null)
          @scope.onUserCancel()
          expect(@scope.bufferUser).toBe(null)
        )
    
        it('should blank the user buffer user on Select Group after New', () ->
          @scope.onUserNew()
          expect(@scope.bufferUser).not.toBe(null)
          @scope.currentGroupId = 2
          @scope.$digest()
          expect(@scope.bufferUser).toBe(null)
        )
    
        it('should copy selection to the user buffer user
            on Select User after New', () ->
          @scope.onUserNew()
          expect(@scope.bufferUser).not.toBe(null)
          expect(@scope.bufferUser._id).toBe(undefined)
          @scope.onUserSelect(4)
          @scope.$digest()
          expect(@scope.bufferUser._id).toBe(4)
        )
    
        it('should update users and select the new user
            on Save after New', () ->
          @scope.onUserNew()
          @scope.bufferUser._id = 43
          @scope.onUserSave()
          @httpBackend.expectGET('/api/users').respond(200,
            _status: 'OK'
            _items: [{
              _id: 4
              username: "brubble"
              },{
              _id: 5
              username: "fflint"
              },{
              _id: 6
              username: "wwoman"
              },{
              _id: 43
              username: "test"
              }]
          )
          @httpBackend.flush()
          expect(@scope.selectedUserId).toBe(43)
          expect(@scope.displayUsers.length).toBe(4)
        )

      )

      describe('with group selected', () ->
        beforeEach( () ->
          @scope.currentGroupId = 2
          @scope.$digest()
          expect(@scope.displayUsers.length).toBe(1)
        )
        
        it('should copy selection to the user buffer user
            on Select User', () ->
          @scope.onUserSelect(6)
          @scope.$digest()
          expect(@scope.bufferUser.username).toBe('wwoman')
        )
        
        it('should add member to group, PUT group,
            and select member on Add', () ->
          @scope.addedUser = @scope.users[0]
          @scope.onUserAdd()
          @httpBackend.expectPUT('/api/usergroups/2',
            _id: 2
            _collection: 'usergroups'
            name: "bedrock"
            title: "Bedrock"
            users: [{
              _id: 6
              username: "wwoman"
            },{
              _id: 4
              _collection: 'users'
              username: "brubble"
            }]
          ).respond(200,
            _status: 'OK'
            _item: {
              _id: 2
              name: "bedrock"
              title: "Bedrock"
              users: [{
                _id: 6
                username: "wwoman"
              },{
                _id: 4
                username: "brubble"
              }]
            }
          )
          @httpBackend.flush()
          expect(@scope.addedUser).toBe(null)
          expect(@scope.selectedUserId).toBe(4)
          expect(@scope.displayUsers.length).toBe(2)
        )
      )
    )

    describe('with user selected', () ->
      beforeEach( () ->
        @scope.onUserSelect(6)
        @scope.$digest()
      )

      describe('with no group selected', () ->
        it('clears selected user on Group change', () ->
          @scope.currentGroupId = 2
          @scope.$digest()
          expect(@scope.selectedUserId).toBe(null)
          expect(@scope.displayUsers.length).toBe(1)
        )

        it('copies user to buffer if selected', () ->
          @scope.onUserSelect(2)
          @scope.$digest()
          expect(@scope.selectedUserId).toBe(2)
          expect(@scope.displayUsers.length).toBe(3)
        )
        
        it('clears selected user if selected again', () ->
          @scope.onUserSelect(6)
          @scope.$digest()
          expect(@scope.selectedUserId).toBe(null)
          expect(@scope.bufferUser).toBe(null)
          expect(@scope.displayUsers.length).toBe(3)
        )

        it('clears selected user and buffer on Cancel', () ->
          @scope.onUserCancel()
          expect(@scope.selectedUserId).toBe(null)
          expect(@scope.bufferUser).toBe(null)
          expect(@scope.displayUsers.length).toBe(3)
        )

        it('should update users and select the new user
            on Save', () ->
          @scope.onUserSave()
          @httpBackend.expectGET('/api/users').respond(200,
            _status: 'OK'
            _items: [{
              _id: 4
              username: "brubble"
              },{
              _id: 5
              username: "fflint"
              },{
              _id: 6
              username: "wwoman"
              }]
          )
          @httpBackend.flush()
          expect(@scope.selectedUserId).toBe(6)
          expect(@scope.displayUsers.length).toBe(3)
        )

        it('should DELETE user and clear selection on Delete', () ->
          @scope.onUserDelete()
          @httpBackend.expectDELETE('/api/users/6').respond(204)
          @httpBackend.expectGET('/api/usergroups').respond(200,
            _status: 'OK'
            _items: [{
              _id: 2
              name: "bedrock"
              title: "Bedrock"
              users: []
            }]
          )
          @httpBackend.expectGET('/api/users').respond(200,
            _status: 'OK'
            _items: [{
              _id: 4
              username: "brubble"
              },{
              _id: 5
              username: "fflint"
              }]
          )
          @httpBackend.flush()
          expect(@scope.selectedUserId).toBe(null)
          expect(@scope.displayUsers.length).toBe(2)
        )


      )

      describe('with group selected', () ->
        beforeEach( ->
          @scope.currentGroupId = 2
          @scope.$digest()
          expect(@scope.displayUsers.length).toBe(1)
          @scope.onUserSelect(6)
          @scope.$digest()
        )

        it('clears selected user on Group change', () ->
          @scope.currentGroupId = null
          @scope.$digest()
          expect(@scope.selectedUserId).toBe(null)
          expect(@scope.displayUsers.length).toBe(3)
        )

        it('clears selected user if selected again', () ->
          @scope.onUserSelect(6)
          @scope.$digest()
          expect(@scope.selectedUserId).toBe(null)
          expect(@scope.bufferUser).toBe(null)
          expect(@scope.displayUsers.length).toBe(1)
        )

        it('clears selected user and buffer on Cancel', () ->
          @scope.onUserCancel()
          expect(@scope.selectedUserId).toBe(null)
          expect(@scope.bufferUser).toBe(null)
          expect(@scope.displayUsers.length).toBe(1)
        )

        it('should update users and select the new user
            on Save', () ->
          @scope.onUserSave()
          @httpBackend.expectGET('/api/users').respond(200,
            _status: 'OK'
            _items: [{
              _id: 4
              username: "brubble"
              },{
              _id: 5
              username: "fflint"
              },{
              _id: 6
              username: "wwoman"
              }]
          )
          @httpBackend.flush()
          expect(@scope.selectedUserId).toBe(6)
          expect(@scope.displayUsers.length).toBe(1)
        )

        it('should remove user from group and clear selection
            on Remove', () ->
          @scope.onUserRemove()
          @httpBackend.expectPUT('/api/usergroups/2',
            _id: 2
            _collection: 'usergroups'
            name: "bedrock"
            title: "Bedrock"
            users: []
          ).respond(200,
            _status: 'OK'
            _item: {
              _id: 2
              name: "bedrock"
              title: "Bedrock"
              users: []
            }
          )
          @httpBackend.flush()
          expect(@scope.selectedUserId).toBe(null)
          expect(@scope.displayUsers.length).toBe(0)
        )
      )
    )
  )
)
