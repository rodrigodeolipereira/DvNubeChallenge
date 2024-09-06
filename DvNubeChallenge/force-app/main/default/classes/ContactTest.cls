@isTest
public with sharing class ContactTest {
    static final Integer ADULT_AGE = 18;
    static final String MESSAGE_REPORTS_REQUIRED = 'Reports To field required if Age is less than 18';

    @isTest
    static void reportsToRequiredAgeLess18() {
        Contact contact = getContact(ADULT_AGE - 1);

        Test.startTest();
        Database.SaveResult results = Database.insert(contact, false);
        Test.stopTest();

        System.assertEquals(results.isSuccess(), false, 'Contact under 18 years old cannot be recorded without ReportTo');
        System.assertEquals(checkHasMessageAgeLess18(results), true, 'Validation rule called validationReportsToRequired didn\'t work');
    }

    @isTest
    static void reportsToRequiredAgeMoreEquals18() {
        Contact contact = getContact(ADULT_AGE);

        Test.startTest();
        Database.SaveResult results = Database.insert(contact, false);
        Test.stopTest();

        System.assertEquals(results.isSuccess(), true, 'Contact equal or over 18 years old can be recorded without ReportTo');
        System.assertEquals(checkHasMessageAgeLess18(results), false, 'Validation rule called validationReportsToRequired didn\'t work');
    }

    static Contact getContact(Integer currentAge) {
        Contact contact = new Contact();
        contact.FirstName = 'Ashley';
        contact.LastName = 'James';
        contact.Birthdate = Date.today().addYears(currentAge * -1);
        return contact;
    }    

    static Boolean checkHasMessageAgeLess18(Database.SaveResult results) {
        for(Database.Error error: results.getErrors()) {
            if (error.getMessage() == MESSAGE_REPORTS_REQUIRED) {
                return true;
            }
        }        

        return false;
    }
}