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
        @groupNew = $('#groupActions').element(By.buttonText('New'))
        @groupEdit = $('#groupActions').element(By.buttonText('Edit'))
        @groupDelete = $('#groupActions').element(By.buttonText('Delete'))
        @groupForm = new GroupForm($('#groupForm'))
        
        @userAdd = $('#userAdd')        
        @userAddInput = @userAdd.$('input')
        @userAddButton = @userAdd.$('button')
        @userRemove = element(By.buttonText('Remove'))
        
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

    xit('should allow group creation, cancellation, editing and deletion', () ->
        form = @page.groupForm
        expect(form.isDisplayed()).toBe(false)

        @page.groupNew.click()
        expect(form.isDisplayed()).toBe(true)
        form.name.sendKeys('test')
        form.title.sendKeys('Test Group')
        form.cancel.click()
        expect(@page.groupSelect.$('option:checked').getText()).toBe('All Users')
        expect(@page.userTable.all(By.css('tr')).count()).toBe(5)
        expect(form.isDisplayed()).toBe(false)
        
        @page.groupNew.click()
        expect(form.isDisplayed()).toBe(true)
        form.name.sendKeys('test')
        form.title.sendKeys('Test Group')
        form.save.click()
        expect(@page.groupSelect.$('option:checked').getText()).toBe('Test Group')
        expect(@page.userTable.all(By.css('tr')).count()).toBe(1)
        expect(form.isDisplayed()).toBe(false)
        
        @page.groupEdit.click()
        expect(form.isDisplayed()).toBe(true)
        expect(form.name.getAttribute('value')).toBe('test')
        form.title.clear()
        form.title.sendKeys('Test Group 2')
        form.save.click()
        expect(@page.groupSelect.$('option:checked').getText()).toBe('Test Group 2')
        expect(@page.userTable.all(By.css('tr')).count()).toBe(1)
        expect(form.isDisplayed()).toBe(false)

        @page.groupDelete.click()
        expect(@page.groupSelect.$('option:checked').getText()).toBe('All Users')
        expect(@page.userTable.all(By.css('tr')).count()).toBe(5)
        expect(form.isDisplayed()).toBe(false)
    )

    it('should adding and remove of group memberships', () ->
        expect(@page.userTable.all(By.css('tr')).count()).toBe(5)
        @page.selectGroup(1)
        expect(@page.userTable.all(By.css('tr')).count()).toBe(3)
        @page.userAddInput.sendKeys('Wo')
        @page.userAdd.$('a').click()
        @page.userAddButton.click()
        expect(@page.userTable.all(By.css('tr')).count()).toBe(4)
        @page.userTable.element(By.cssContainingText('tr', 'Barney')).click()
        @page.userRemove.click()
        expect(@page.userTable.all(By.css('tr')).count()).toBe(3)
        expect(@page.userTable.all(By.cssContainingText('tr', 'Barney')).count()).toBe(0)
    )
)
