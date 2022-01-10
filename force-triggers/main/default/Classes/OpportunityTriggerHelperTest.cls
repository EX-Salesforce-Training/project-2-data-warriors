@isTest
public class OpportunityTriggerHelperTest {
    
    
    public static void createAccounts(Integer num, String stage, String accountName){
        
        List<Account> accs = new List<Account>();
        
        for(Integer i=0; i<num; i++){
            accs.add(new Account(name=accountName + i)); 
        }
        
        insert accs;
        
        List<Opportunity> opps = new List<Opportunity>();
        for(Account account:[SELECT Id, Name FROM Account]){
            Opportunity opp = new Opportunity(Name='Opportunity Test' + account.Name, AccountId = account.Id, StageName =stage, CloseDate=System.today());
            opps.add(opp);
        }
        insert opps;   
        
    }
    
    @isTest private static void accountRatingHotTest(){
        OpportunityTriggerHelperTest.createAccounts(10, 'Closed Won', 'Hot' );
        
        List<Account> getAllAccounts = [SELECT Id, Name, Rating FROM Account];
        
        for(Account acc: getAllAccounts){
            system.assertEquals(acc.Rating, 'Hot');          
        }
        
        
    }
    
    @isTest private static void accountRatingColdTest(){
        OpportunityTriggerHelperTest.createAccounts(10, 'Closed Lost', 'Cold' );
        
        List<Account> getAllAccounts = [SELECT Id, Name, Rating FROM Account];
        
        for(Account acc: getAllAccounts){
            system.assertEquals(acc.Rating, 'Cold');          
        }
        
        
    }
    
    
    
}