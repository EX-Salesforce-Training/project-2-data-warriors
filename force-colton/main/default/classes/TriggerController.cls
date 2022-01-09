public with sharing class TriggerController {
    
    // Adds a standard pricebook entry on newly created products based on Standard Unit Price field.
    public static void addStandardPrice(Map<Id, Product2> newProducts) {
        // Active standard pricebook that holds product prices
        Pricebook2 priceBook = [SELECT Id FROM Pricebook2 WHERE IsStandard = TRUE AND IsActive = TRUE];
        // Create empty pricebook entry list for new entries
        List<PricebookEntry> pbEntryList = new List<PricebookEntry>();

        // Iterate through products and add an entry to the pricebook
        for(Product2 p : newProducts.values()) {
            if (p.Product_Price__c != null){
                pbEntryList.add(
                    new PricebookEntry( Pricebook2Id = priceBook.Id, 
                                        Product2Id = p.Id, 
                                        UnitPrice = p.Product_Price__c, 
                                        IsActive = p.IsActive, 
                                        UseStandardPrice = FALSE
                                        
                ));
            }
        }
        insert pbEntryList;
    }
    
    // Updates standard pricebook for product based on "Product_Price" custom field in product.
    public static void updateStandardPrice(Map<Id, Product2> newProducts) {
        // List of existing pricebook entries in the newProducts map
        List<PricebookEntry> existPBEntryList = [SELECT Id, UnitPrice, Product2Id FROM PricebookEntry WHERE Product2ID IN: newProducts.keySet()];
        // Null and empty checks
        if (existPBEntryList != null && !existPBEntryList.isEmpty()) {
            // Iterate through entries and update unitprice of non-null values
            for (PricebookEntry pbe : existPBEntryList){
                Product2 temp = newProducts.get(pbe.Product2Id);
                if(pbe != null && temp.Product_Price__c != null){
                    pbe.UnitPrice = temp.Product_Price__c;
                }
                
            }
            update existPBEntryList;
        }
    }

    // // Updates product with a unique generated product code in the following format:
    // // {AA}-{0000} (two letters followed by a dash and 4 digits -- i.e. SN-1001)
    // public static void generateProductCode(List<Product2> newProducts) {
    //     // Store all product codes in a string list
    //     List<String> existingCodes = new List<String>();
    //     for (Product2 p : [SELECT ProductCode FROM Product2]) {
    //         existingCodes.add(p.ProductCode);
    //     }
    //     // List of products to update
    //     List<Product2> updateProds = [SELECT Id, ProductCode, Family FROM Product2 WHERE Id IN :newProducts AND (ProductCode = '' OR ProductCode = null)];
        
    //     // generates a product code for products that don't have one.
    //     for(Product2 p : updateProds) {
    //         p.ProductCode = getProductCode(p, existingCodes);
    //         existingCodes.add(p.ProductCode);
    //     }
    //     update updateProds;
    // }

    // // generateProductCode helper method that houses logic for creating a unique randomized product code
    // private static String getProductCode(Product2 p, List<String> oldCodes) {
    //     String codeLetters = '';
    //     List<String> prodFamily = Utilities.picklist_values('Product2', 'Family');

    //     for(String s : prodFamily){
    //         if(s.equals(p.Family)) {
    //             codeLetters += s.toUpperCase().substring(0,2) + '-';
    //         }
    //     }

    //     String newCode = '';
    //     do {
    //         Integer rand4Digits = Math.round((Math.random() * (9000) + 1000));
    //         newCode = codeLetters + String.valueOf(rand4Digits);
    //     } while (oldCodes.contains(newCode));
    //     return newCode;
    // }

    // public static void setProductFamilyIcon(List<Product2> newProducts) {
    //     StaticResource icon = [SELECT Id, Body FROM StaticResource WHERE Name = 'productFamilyIcons' LIMIT 1]
    //     for(Product2 p : newProducts.values()){
            
    //     }
    // }
}