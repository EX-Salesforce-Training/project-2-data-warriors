public with sharing class AccountTriggerHelper {
    public static void NewOpportunity(List<Account> Accounts) {
        List<Opportunity> optyList = new List<Opportunity>();

            for (Account a:Accounts) {
                Opportunity opp =  new Opportunity();
                opp.AccountId = a.id;
                opp.Name = a.Name; //account name = school name
                opp.StageName = 'Prospecting';
                opp.CloseDate = System.Today()+7;
                optyList.add(opp);
            }
            insert optyList;
    }
}
