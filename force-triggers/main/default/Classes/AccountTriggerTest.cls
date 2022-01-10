@isTest
public class AccountTriggerTest {
    @isTest
    public static void AccountTriggerTestMethod() {
        Account acc = new Account();
        acc.Name = 'Test School';
        insert acc;
        System.AssertEquals(acc.Name, 'Test School');

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.Accountid = acc.id;
        opp.StageName = 'Prospecting';
        opp.CloseDate = System.Today().addDays(7);   
        insert opp;
        System.AssertEquals(opp.Name, 'Test Opportunity');     
    }
}
