class GroupForm
    constructor: (@elem) ->
        @name = @elem.element(By.model('item.name'))
        @title = @elem.element(By.model('item.title'))
        @save = @elem.element(By.buttonText('Save'))
        @cancel = @elem.element(By.buttonText('Cancel'))
        
    isDisplayed: () ->
        @elem.isDisplayed()


class UserForm
    constructor: (@elem) ->
        @username = @elem.element(By.model('item.username'))
        @firstName = @elem.element(By.model('item.first_name'))
        @lastName = @elem.element(By.model('item.last_name'))
        @staff = @elem.element(By.model('item.staff'))
        @superuser = @elem.element(By.model('item.superuser'))
        @save = @elem.element(By.buttonText('Save'))
        @cancel = @elem.element(By.buttonText('Cancel'))

    isEnabled: () ->
        @username.isEnabled()



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
        
        @userNew = $('#userActions').element(By.buttonText('New'))
        @userDelete = $('#userActions').element(By.buttonText('Delete'))
        @userForm = new UserForm($('#userForm'))
        @userTable = $('#users')
        
    selectGroup: (ind) ->
        @groupSelect.click()
        @groupSelect.all(By.css('option')).get(ind+1).click()
        
        
    checkUserRow: (username) ->
        @userTable.element(By.cssContainingText('tr', username)).isPresent()
        
    getUserRow: (username) ->
        @userTable.element(By.cssContainingText('tr', username))

    clickUserRow: (username) ->
        row = @getUserRow(username)
        row.click()


describe('user page', () ->
    beforeEach( ->
        browser.get('/build')
        @page = new UserPage()
    )

    afterEach( ->
        browser.driver.get(browser.baseUrl + '/_reset')
    )

    it('should allow group creation, cancellation, editing and deletion', () ->
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
        @page.clickUserRow('brubble')
        @page.userRemove.click()
        expect(@page.userTable.all(By.css('tr')).count()).toBe(3)
        expect(@page.checkUserRow('brubble')).toBe(false)
    )

    it('should allow user creation, cancellation, editing and deletion', () ->
        form = @page.userForm
        expect(form.isEnabled()).toBe(false)
        expect(@page.userTable.all(By.css('tr')).count()).toBe(5)
        
        @page.userNew.click()
        expect(form.isEnabled()).toBe(true)
        form.username.sendKeys('robin')
        form.firstName.sendKeys('Boy')
        form.lastName.sendKeys('Wonder')
        form.cancel.click()
        expect(form.isEnabled()).toBe(false)
        expect(@page.userTable.all(By.css('tr')).count()).toBe(5)
        expect(@page.checkUserRow('robin')).toBe(false)
        
        @page.userNew.click()
        expect(form.isEnabled()).toBe(true)
        form.username.sendKeys('robin')
        form.firstName.sendKeys('Boy')
        form.lastName.sendKeys('Wonder')
        form.save.click()
        expect(form.isEnabled()).toBe(true)
        expect(@page.userTable.all(By.css('tr')).count()).toBe(6)
        expect(@page.checkUserRow('robin')).toBe(true)
        
        @page.clickUserRow('brubble')
        expect(form.isEnabled()).toBe(true)
        expect(form.username.getAttribute('value')).toBe('brubble')
        form.username.clear()
        form.username.sendKeys('brubble2')
        form.cancel.click()
        expect(form.isEnabled()).toBe(false)
        expect(@page.userTable.all(By.css('tr')).count()).toBe(6)
        expect(@page.checkUserRow('brubble')).toBe(true)
        expect(@page.checkUserRow('brubble2')).toBe(false)
        
        @page.clickUserRow('robin')
        expect(form.isEnabled()).toBe(true)
        expect(form.username.getAttribute('value')).toBe('robin')
        form.username.clear()
        form.username.sendKeys('bwonder')
        form.save.click()
        expect(form.isEnabled()).toBe(true)
        expect(@page.userTable.all(By.css('tr')).count()).toBe(6)
        expect(@page.checkUserRow('robin')).toBe(false)
        expect(@page.checkUserRow('bwonder')).toBe(true)
        
        @page.userDelete.click()
        expect(form.isEnabled()).toBe(false)
        expect(@page.userTable.all(By.css('tr')).count()).toBe(5)
        expect(@page.checkUserRow('bwonder')).toBe(false)
    )

)
