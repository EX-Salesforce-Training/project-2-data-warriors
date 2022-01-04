trigger UserTrigger on User (after insert) {
    
 	List<Account> accs = new List<Account>();
    //looping through new users
    for(User user: Trigger.new){
        //if school name field is not blank 
        system.debug('user trigger');
        if(String.isNotBlank(user.School_Name__c)){
            //create new account with name of that school name
        	Account acc = new Account(Name=user.School_Name__c);
            accs.add(acc);
            system.debug('Account Created' + acc);
        }
    }
    
    // insert the account list 
    insert accs;

    Account registrantAccount = [SELECT Id, Name From Account WHERE Name = 'Registrants'];
    
    List<Contact> contacts = [SELECT firstName, lastName, accountId FROM Contact WHERE accountId =: registrantAccount.Id];
    
    List<Account> allAccs = [SELECT Id, Name FROM Account];
    
    for(User user: Trigger.new){
        for(Contact contact: contacts){
            if(user.Name == contact.firstName + ' ' + contact.lastName){
                for(Account acc: allAccs){
                    if(acc.Name == user.School_Name__c){
                        contact.AccountId = acc.Id;
                    }
                }
            }
        }
    }
    
    
	
}