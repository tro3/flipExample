
describe('userform', () ->
  beforeEach(module('app.userform'))
    
  beforeEach(inject((_$compile_, _$rootScope_, _$httpBackend_, flipDoc) ->
    @compile = _$compile_
    @scope = _$rootScope_.$new()
    @httpBackend = _$httpBackend_
    @flipDoc = flipDoc
  ))


  describe('will a null item', () ->
    beforeEach( () ->
      @scope.item = null
      @element = @compile("<div user-form item=\"item\"></div>")(@scope)
      @scope.$digest()
    )

    it('has disabled inputs', () ->
      expect(@element.find('input').eq(0).prop('disabled')).toBe(true)
      expect(@element.find('button').eq(0).prop('disabled')).toBe(true)
    )

  )

  describe('with an active item', () ->
    beforeEach( () ->
      @scope.item = @flipDoc('users',
        _id: 4
        _auth:
          _create: true
          _edit: true
        username: "brubble"
        first_name: "Barney"
        last_name: "Rubble"
        location: "Bedrock"
        active: true
      )
      @element = @compile("<div user-form item=\"item\"></div>")(@scope)
      @scope.$digest()
    )

    it('has enabled inputs', () ->
      expect(@element.find('input').eq(0).prop('disabled')).toBe(false)
      expect(@element.find('button').eq(0).prop('disabled')).toBe(false)
    )

    it('saves item on Save', () ->
      @httpBackend.expectPUT('/api/users/4',
        _id: 4
        _collection: "users"
        _auth:
          _create: true
          _edit: true
        username: "brubble"
        first_name: "Barney"
        last_name: "Rubble"
        location: "Bedrock"
        active: true
      ).respond(200,
          _status: 'OK',
          _item:
            _id: 4
            _auth:
              _create: true
              _edit: true
            username: "brubble"
            first_name: "Barney"
            last_name: "Rubble"
            location: "Bedrock"
            active: true
      )
      @element.find('button').triggerHandler('click')
      @httpBackend.flush()
    )
  )

)


