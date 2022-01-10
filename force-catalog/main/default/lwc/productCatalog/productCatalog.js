import { LightningElement, api, wire } from 'lwc';
import getAllProducts from '@salesforce/apex/ProductController.getAllProducts';
import getProductFamily from '@salesforce/apex/ProductController.getProductFamily';

// Use LMS and message channels to pass selected product from an event
import { subscribe, MessageContext, APPLICATION_SCOPE } from 'lightning/messageService';
import FILTERLMS from '@salesforce/messageChannel/filterProduct__c';


// import apex method to get products from a controller class
import getProducts from '@salesforce/apex/ProductController.getProducts';
import getProduct from '@salesforce/apex/ProductController.getProduct';
export default class ProductCatalog extends LightningElement {
    @api searchBarVisible = false;

    @api tilesAreDraggable = false;
    
    // Declare default values for page number, products on page, and empty array for search filters
    pageNumber = 1;
    totalItemCount = 0;
    pageSize;
    filters={};

    //Loads the context for the LMS
    @wire(MessageContext) messageContext;

    // { filters: '$filters', pageNumber: '$pageNumber' }
    // use wire to access valid products and use $ to keep the filters and pageNum dynamic
    @wire(getProduct, { filters: '$filters', pageNumber: '$pageNumber'})
    products;

    connectedCallback() {
        // Subscribe to ProductsFiltered messageq
        subscribe(
            this.messageContext,
            FILTERLMS,
            (message) => { this.handleFilterChange(message) }, {scope: APPLICATION_SCOPE}
        );
    }

    // handler for search bar filters
    handleSearchKeyChange(event) {
        this.filters = { searchKey: event.target.value.toLowerCase()};
        this.pageNumber = 1;
    }

    handleFilterChange(message) {
        console.log("before " + filters);
        this.filters = message.filters.inputValue;
        // this.filters = { ...message.filters };
        this.pageNumber = 1;
        console.log("after " + filters);
    }

    // handlers for tracking the current page number
    handlePreviousPage() {
        this.pageNumber = this.pageNumber - 1;
    }
    handleNextPage() {
        this.pageNumber = this.pageNumber + 1;
    }
}