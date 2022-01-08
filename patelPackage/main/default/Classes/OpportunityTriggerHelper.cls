public with sharing class OpportunityTriggerHelper {
    public static void AccountRating(List<Opportunity> opportunity){
        Set<id> AccountIdClosedWon = new set<id>();
        Set<id> AccountIdClosedLost = new set<id>();
        
        for(Opportunity opp: opportunity){
            if(opp.stageName == 'Closed Won'){
                accountIdClosedWon.add(opp.AccountId);
            }
            
            if(opp.stageName == 'Closed Lost'){
                accountIdClosedLost.add(opp.AccountId);
            }
        }
        List<Account> accsHot = [SELECT id, Rating FROM Account WHERE Id IN: AccountIdClosedWon];
        List<Account> accsCold = [SELECT id, Rating FROM Account WHERE Id IN: AccountIdClosedLost];
        List<Account> accountRating = new List<Account>();
        
        for(Account acc: accsHot){
            acc.Rating = 'Hot';
            accountRating.add(acc);
        }
        
        for(Account acc: accsCold){
            acc.Rating = 'Cold';
            accountRating.add(acc);
         }
        
        update accountRating;        	      
    }
}