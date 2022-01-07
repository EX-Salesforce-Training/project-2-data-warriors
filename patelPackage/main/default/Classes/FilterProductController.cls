public with sharing class FilterProductController {
    @AuraEnabled (Cacheable = true)
    public static List<Product2> getProduct(String value){
        String key = '%' + value+ '%';
        return [SELECT Id, Name, ProductCode, Description, Family, Product_Price__c FROM Product2 WHERE Name LIKE: key];
        
    }

    @AuraEnabled (Cacheable = true)
    public static List<Product2> getAllProduct(){
        return [SELECT Id, Name, ProductCode, Description, Family, Product_Price__c FROM Product2 WHERE Name =: 'Pencil v1' limit 1];
        
    }


    // @AuraEnabled (Cacheable = true)
    // public static List<Product2> getProductByCategory(String value){
    //     String key = '%' + value+ '%';
    //     return [SELECT Id, Name, ProductCode, Description, Family, Product_Price__c FROM Product2 WHERE Family LIKE: key];
        
    // }
}
