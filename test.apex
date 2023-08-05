

// testing apex code //


Contact jane = new Contact(FirstName='Jane',
                         LastName='Smith',
                         Email='jane.smith@example.com',
                         Description='Contact of the day');
insert jane;
// 1. Upsert using an idLookup field
// Create a second sObject variable.
// This variable doesn’t have any ID set.
Contact jane2 = new Contact(FirstName='Jane',
                         LastName='Smith',
                         Email='jane.smith@example.com',
                         Description='Prefers to be contacted by email.');
// Upsert the contact by using the idLookup field for matching.
upsert jane2 Contact.fields.Email;
// Verify that the contact has been updated
System.assertEquals('Prefers to be contacted by email.',
                   [SELECT Description FROM Contact WHERE Id=:jane.Id].Description);





// assertEquals //




Contact jane = new Contact(FirstName='Jane',
                         LastName='Smith',
                         Email='jane.smith@example.com',
                         Description='Contact of the day');
insert jane;
// 1. Upsert using an idLookup field
// Create a second sObject variable.
// This variable doesn’t have any ID set.
Contact jane2 = new Contact(FirstName='Jane',
                         LastName='Smith',
                         Email='jane.smith@example.com',
                         Description='Prefers to be contacted by email.');
// Upsert the contact by using the idLookup field for matching.
upsert jane2 Contact.fields.Email;
// Verify that the contact has been updated
System.assertEquals('Prefers to be contacted by email.',
                   [SELECT Description FROM Contact WHERE Id=:jane.Id].Description);



// delete


Contact[] contactsDel = [SELECT Id FROM Contact WHERE LastName='Smith'];
delete contactsDel;




// excpetinons //

try {
    // This causes an exception because
    //   the required Name field is not provided.
    Account acct = new Account();
    // Insert the account
    insert acct;
} catch (DmlException e) {
    System.debug('A DML exception has occurred: ' +
                e.getMessage());
}


// DB methods //



// Create a list of contacts
List<Contact> conList = new List<Contact> {
        new Contact(FirstName='Joe',LastName='Smith',Department='Finance'),
        new Contact(FirstName='Kathy',LastName='Smith',Department='Technology'),
        new Contact(FirstName='Caroline',LastName='Roth',Department='Finance'),
        new Contact()};
// Bulk insert all contacts with one DML call
Database.SaveResult[] srList = Database.insert(conList, false);
// Iterate through each returned result
for (Database.SaveResult sr : srList) {
    if (sr.isSuccess()) {
        // Operation was successful, so get the ID of the record that was processed
        System.debug('Successfully inserted contact. Contact ID: ' + sr.getId());
    } else {
        // Operation failed, so get all errors
        for(Database.Error err : sr.getErrors()) {
            System.debug('The following error has occurred.');
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
            System.debug('Contact fields that affected this error: ' + err.getFields());
	 }
    }
}








Account acct = new Account(Name='SFDC Account');
insert acct;
// Once the account is inserted, the sObject will be
// populated with an ID.
// Get this ID.
ID acctID = acct.ID;
// Add a contact to this account.
Contact mario = new Contact(
    FirstName='Mario',
    LastName='Ruiz',
    Phone='415.555.1212',
    AccountId=acctID);
insert mario;







// Query for the contact, which has been associated with an account.
Contact queriedContact = [SELECT Account.Name
                          FROM Contact
                          WHERE FirstName = 'Mario' AND LastName='Ruiz'
                          LIMIT 1];
// Update the contact's phone number
queriedContact.Phone = '(415)555-1213';
// Update the related account industry
queriedContact.Account.Industry = 'Technology';
// Make two separate calls
// 1. This call is to update the contact's phone.
update queriedContact;
// 2. This call is to update the related account's Industry field.
update queriedContact.Account;



public class OlderAccountsUtility {
    public static void updateOlderAccounts() {
      // Get the 5 oldest accounts
      Account[] oldAccounts = [SELECT Id, Description FROM Account ORDER BY CreatedDate ASC LIMIT 5];
      // loop through them and update the Description field
      for (Account acct : oldAccounts) {
          acct.Description = 'Heritage Account';
      }
      // save the change you made
      update oldAccounts;
    }
}







public class AccountHandler {
    public static Account insertNewAccount(String accountName) {
        Account newAccount = new Account();
        newAccount.Name = accountName;
        try {
            insert newAccount;
            return newAccount;
        } catch (DmlException e) {
            return null;
        }
    }
}
