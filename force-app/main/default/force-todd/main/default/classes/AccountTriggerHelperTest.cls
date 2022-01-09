@isTest
public with sharing class AccountTriggerHelperTest {
    @isTest
    private static void NewOpportunityTest() {
        Account acc = new Account();
        acc.Name = 'Test School';
        insert acc;
        System.AssertEquals(acc.Name, 'Test School');

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.Accountid = acc.id;
        opp.StageName = 'Prospecting';
        opp.CloseDate = System.Today()+7;   
        insert opp;
        System.AssertEquals(opp.Name, 'Test Opportunity'); 
    }

    /*@isTest
    private static void BulkOpportunityTest() {
        List<Account> accs = new List<Account>();
		List<Opportunity> opps = new List<Opportunity>();

        for(integer i = 0; i < 100; i++ ) {
            Account acc = new Account();
            acc.Name = 'Test School' + i;
            accs.add(acc);
            
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Opportunity' + i;
            opp.Accountid = acc.id;
            opp.StageName = 'Prospecting';
            opp.CloseDate = System.Today()+7;  
            opps.add(opp);
        }
	insert accs;
	insert opps;
        
        for(integer i = 0; i < 100; i++ ) {
            for(Opportunity opp: opps) {
                System.assertEquals(opp.Name, 'Test Opportunity' + i);
            }
        }
    
    }*/
}
