public with sharing class productController {
 
    @AuraEnabled(cacheable=true)
    public static List<Product2> getProduct() {

        return [SELECT name, DisplayURL, Product_Price__c FROM Product2 LIMIT 1];
    }
}