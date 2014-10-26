describe( 'appCtrl', () ->
  
  describe( 'isCurrentUrl', () ->
    beforeEach(
      module('appTop')
    )

    beforeEach(inject(($controller, _$location_, $rootScope) ->
      @location = _$location_
      @scope = $rootScope.$new()
      @ctrl = $controller('appCtrl',
        $location: @location,
        $scope: @scope
      )
    ))

    it('should pass a dummy test', () ->
      expect(@ctrl).toBeTruthy()
    )
  )
)
