public with sharing class ProductController {
    // number of product tiles to be displayed on the page
    static Integer PAGE_SIZE = 8;

    // Nested filters class for the filtering of products through the search bar
    public class Filters {
        @AuraEnabled
        public String searchKey { get; set; }
    }

    @AuraEnabled(Cacheable=true)
    public static PagedResult getProducts(Filters filters, Integer pageNum){
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
        Integer offset = (pageNum - 1) * pageSize;

        // store fields and query results in empty paged result object
        PagedResult result = new PagedResult();
        result.pageSize = pageSize;
        result.pageNum = pageNum;
        // use AggregateResult query count() to dynamically return number of records with given criteria
        result.totalProductCount = Database.countQuery(
            'SELECT count() FROM Product2 ' + whereClause
        );
        // store query records returned after filters, limits, and enforcing security
        result.records = Database.query(
            'SELECT Id, ProductCode, Family, Name, Product_Price__c' +
            ' FROM Product2 ' + whereClause + 
            ' ORDER BY Name LIMIT :pageSize OFFSET :offset' 
        );
        return result;
    }



    @AuraEnabled(cacheable=true)
    public static List<Product2> getAllProducts(){
        return [
            SELECT Id, ProductCode, Family, Name, Product_Price__c
            FROM Product2
            ORDER BY Name
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Product2> getProductFamily(String fam){
        return [
            SELECT Id, ProductCode, Family, Name, Product_Price__c
            FROM Product2
            WHERE Family = :fam
        ];
    }
}
