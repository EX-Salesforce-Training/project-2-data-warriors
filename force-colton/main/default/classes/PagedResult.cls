public with sharing class PagedResult {
    @AuraEnabled
    public Integer pageSize { get; set; }

    @AuraEnabled
    public Integer pageNum { get; set; }

    @AuraEnabled
    public Integer totalProductCount { get; set; }

    @AuraEnabled
    public Object[] records { get; set; }
}
