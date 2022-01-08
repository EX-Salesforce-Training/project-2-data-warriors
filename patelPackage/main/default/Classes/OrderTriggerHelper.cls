public with sharing class OrderTriggerHelper {
    public static void orderBillingandShippingAddress(List<Order> ord){
                    // when order gets created copy the billing address 
                    Set<id> accIds = new Set<id>();

                    for(Order order: ord){
                        accIds.add(order.AccountId);
                    }
        
                    List<Account> account = [SELECT Id, Name, BillingStreet, BillingCity, BillingCountry,BillingState,BillingPostalCode, ShippingStreet, ShippingCity, ShippingCountry,ShippingState,ShippingPostalCode FROM Account WHERE Id IN: accIds];
        
                    for(Account acc : account){
                        for(Order order: ord){
                            if(acc.Id == order.AccountId){
                                order.BillingStreet = acc.BillingStreet;
                                order.BillingCity = acc.BillingCity;
                                order.BillingCountry = acc.BillingCountry;
                                order.BillingState = acc.BillingState;
                                order.BillingPostalCode = acc.BillingPostalCode;


                                order.ShippingStreet = acc.ShippingStreet;
                                order.ShippingCity = acc.ShippingCity;
                                order.ShippingCountry = acc.ShippingCountry;
                                order.ShippingState = acc.ShippingState;
                                order.ShippingPostalCode = acc.ShippingPostalCode;
                                
                            }
                        }
                    }
                    
    }
}
