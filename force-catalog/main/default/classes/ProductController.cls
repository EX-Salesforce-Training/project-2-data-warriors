public with sharing class ProductController {
    // number of product tiles to be displayed on the page
    static Integer PAGE_SIZE = 8;

    // Nested filters class for the filtering of products through the search bar
    public class Filters {
        @AuraEnabled
        public String inputValue { get; set; }
        @AuraEnabled
        public Decimal price { get; set; }
        @AuraEnabled
        public String[] categories { get; set; }
    }

    @AuraEnabled(Cacheable=true)
    public static List<Product2> getProducts(Filters filters){
        // storing SOQL statement in strings to keep query calls dynamic
        String key = '';
        String whereClause = '';
        Decimal price;
        String[] categories, criteria = new List<String>{};

        // if filters isn't null and the searchKey holds a value, concatenate
        // SOQL statement to retrieve records withing the filter
        if(filters != null) {
            price = filters.price;
            categories = filters.categories;
            System.debug('Categories: ' +  categories);
            if(!String.isEmpty(filters.inputValue)) {
                key = '%' + filters.inputValue + '%';
                criteria.add('Name LIKE :key');
                System.debug('Key: ' + key);
            }
            if (filters.price >= 0 ){
                price = filters.price;
                criteria.add('Product_Price__c <= :price');
            }
            if (filters.categories!= null && !filters.categories.isEmpty()) {
                categories = filters.categories;
                criteria.add('Family IN :categories');
                System.debug('Categories: ' +  categories);
            }
            if (criteria.size() > 0) {
                whereClause = 'WHERE ' + String.join(criteria, ' AND ');
                System.debug('where clause: ' + whereClause);
            }
        }

        String query = 'SELECT Id, ProductCode, familyImag__c, Family, Name, Product_Price__c, StockKeepingUnit '
                       + 'FROM Product2 '+ whereClause
                       + ' ORDER BY Name';
        System.debug('SOQL: ' + query);
        return Database.query(query);
        // // create integer to hold how many records we will LIMIT  in SOQL Query
        // Integer pageSize = ProductController.PAGE_SIZE;

        // // integer to contain how many records to offset depending on page number in SOQL Query
        // Integer offset = (pageNumber - 1) * pageSize;

        // // store fields and query results in empty paged result object
        // PagedResult result = new PagedResult();
        // result.pageSize = pageSize;
        // result.pageNumber = pageNumber;
        // // use AggregateResult query count() to dynamically return number of records with given criteria
        // result.totalItemCount = Database.countQuery(
        //     'SELECT count() FROM Product2 ' + whereClause
        // );
        // // store query records returned after filters, limits, and enforcing security
        // result.records = Database.query(
        //     'SELECT Id, ProductCode, familyImag__c, Family, Name, Product_Price__c, StockKeepingUnit' +
        //     ' FROM Product2 ' + whereClause + 
        //     ' ORDER BY Name LIMIT :pageSize OFFSET :offset' 
        // );
    }

    // Getting Information on a single product to display prices in the carts
    @AuraEnabled
    public static Product2 getProductFromId(String Id) {
        Product2 product;
        if(Schema.SObjectType.Product2.isAccessible()){
            String ProductId = Id;
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

    @AuraEnabled (Cacheable = true)
    public static List<Product2> getOneProduct(){
        return [SELECT Id, Name, ProductCode, Description, Family, Product_Price__c FROM Product2 WHERE Name =: 'Pencil' limit 1];
        
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
