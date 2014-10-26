class GroupForm
    constructor: (@elem) ->
        @name = @elem.element(By.model('item.name'))
        @title = @elem.element(By.model('item.title'))
        @save = @elem.element(By.buttonText('Save'))
        @cancel = @elem.element(By.buttonText('Cancel'))
        
    isDisplayed: () ->
        @elem.isDisplayed()


class UserPage
    constructor: () ->
        @groupSelect = element(By.model('currentGroupId'))
        @groupNew = element.all(By.buttonText('New')).get(0)
        @groupForm = new GroupForm($('#groupForm'))
        @userTable = $('#users')
        
    selectGroup: (ind) ->
        @groupSelect.click()
        @groupSelect.all(By.css('option')).get(ind+1).click()
        


describe('user page', () ->
    beforeEach( ->
        browser.get('/build')
        @page = new UserPage()
    )

    afterEach( ->
        browser.driver.get(browser.baseUrl + '/_reset')
    )

    it('should contain the group select, which should set displayed users', () ->
        expect(@page.groupSelect).toBeTruthy()
        expect(@page.userTable.all(By.css('tr')).count()).toBe(5)
        @page.selectGroup(1)
        expect(@page.userTable.all(By.css('tr')).count()).toBe(3)
    )

    it('should allow group creation', () ->
        form = @page.groupForm
        expect(form.isDisplayed()).toBe(false)
        @page.groupNew.click()
        expect(form.isDisplayed()).toBe(true)
        form.name.sendKeys('test')
        form.title.sendKeys('Test Group')
        form.save.click()
        expect(@page.groupSelect.$('option:checked').getText()).toBe('Test Group')
        expect(@page.userTable.all(By.css('tr')).count()).toBe(1)
    )

    it('should allow Cancel after attempted group creation', () ->
        form = @page.groupForm
        @page.groupNew.click()
        expect(form.isDisplayed()).toBe(true)
        form.cancel.click()
        expect(form.isDisplayed()).toBe(false)
    )


)
