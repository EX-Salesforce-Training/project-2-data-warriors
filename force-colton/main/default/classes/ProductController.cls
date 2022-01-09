public with sharing class ProductController {
    // number of product tiles to be displayed on the page
    static Integer PAGE_SIZE = 8;

    // Nested filters class for the filtering of products through the search bar
    public class Filters {
        @AuraEnabled
        public String searchKey { get; set; }
    }

    @AuraEnabled(Cacheable=true)
    public static PagedResult getProducts(Filters filters, Integer pageNumber){
        // storing SOQL statement in strings to keep query calls dynamic
        String key = '';
        String whereClause = '';
        String criteria;
        
        // if filters isn't null and the searchKey holds a value, concatenate
        // SOQL statement to retrieve records withing the filter
        if(filters != null) {
            if(!String.isEmpty(filters.searchKey)) {
                key = '%' + filters.searchKey + '%';
                criteria = 'Name LIKE :key';
                whereClause = 'WHERE ' + criteria;
            }
        }

        // create integer to hold how many records we will LIMIT  in SOQL Query
        Integer pageSize = ProductController.PAGE_SIZE;
        // integer to contain how many records to offset depending on page number in SOQL Query
        Integer offset = (pageNumber - 1) * pageSize;

        // store fields and query results in empty paged result object
        PagedResult result = new PagedResult();
        result.pageSize = pageSize;
        result.pageNumber = pageNumber;
        // use AggregateResult query count() to dynamically return number of records with given criteria
        result.totalItemCount = Database.countQuery(
            'SELECT count() FROM Product2 ' + whereClause
        );
        // store query records returned after filters, limits, and enforcing security
        result.records = Database.query(
            'SELECT Id, ProductCode, familyImag__c, Family, Name, Product_Price__c, StockKeepingUnit' +
            ' FROM Product2 ' + whereClause + 
            ' ORDER BY Name LIMIT :pageSize OFFSET :offset' 
        );
        return result;
    }

    // Getting Information on a single product to display prices in the carts
    @AuraEnabled
    public static Product2 getProduct(String Id) {
        Product2 product;
        if(Schema.SObjectType.Product2.isAccessible()){
            String ProductId = ID;
			 product = [SELECT Name, ProductCode, Product_Price__c FROM Product2 WHERE Id = :ProductId];
        }
		
        return product;
    }

    @AuraEnabled(cacheable=true)
    public static List<Product2> getAllProducts(){
        return [
            SELECT Id, ProductCode, familyImag__c, Family, Name, Product_Price__c, StockKeepingUnit
            FROM Product2
            ORDER BY Name
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Product2> getProductFamily(String fam){
        return [
            SELECT Id, ProductCode, familyImag__c, Family, Name, Product_Price__c, StockKeepingUnit
            FROM Product2
            WHERE Family = :fam
        ];
    }

    // Creating a new Transaction when customers hit the checkout button so that new receipts can be create with the products to link to it
    @AuraEnabled
    public static String newOrder(Account customerAcc, Date startdate, String status) {
 		Order order = new Order();
         order.AccountId = customerAcc.Id;
         order.EffectiveDate = startdate;
         order.Status = status;

        try{
            insert order;
        }catch(Exception e) {
            system.debug(e);
        }
        return order.OrderNumber;
    }
}
