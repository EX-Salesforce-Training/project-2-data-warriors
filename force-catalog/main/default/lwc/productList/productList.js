import { LightningElement, api, wire } from 'lwc';

import { subscribe, MessageContext, APPLICATION_SCOPE } from 'lightning/messageService';
import FILTERLMS from '@salesforce/messageChannel/filterProduct__c';

// import apex method to get products from a controller class
import getProducts from '@salesforce/apex/ProductController.getProducts';


export default class ProductList extends LightningElement {
    @api searchBarVisible = false;
    @api tilesAreDraggable = false;
    
    filters={};
    productList = ''

    //Loads the context for the LMS
    @wire(MessageContext) messageContext;

    // use wire to access valid products and use $ to keep the filters and pageNum dynamic
    @wire(getProducts, { filters: '$filters'})
    products({data, error}) {
        if(data) {
            this.productList = data;
        }
        if(error) {
            console.log(error);
        }
    }

    connectedCallback() {
        // Subscribe to ProductsFiltered message
        subscribe(
            this.messageContext,
            FILTERLMS,
            (message) => { this.handleFilterChange(message) }, {scope: APPLICATION_SCOPE}
        );
    }

    // handler for search bar filters
    handleSearchKeyChange(event) {
        this.filters = { searchKey: event.target.value.toLowerCase()};
    }

    handleFilterChange(message) {
        this.filters = {...message.filters};
    }
}