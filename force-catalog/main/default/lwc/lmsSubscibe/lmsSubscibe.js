// import { LightningElement, wire } from 'lwc';

// import FILTERLMS from '@salesforce/messageChannel/filterProduct__c';
// import { subscribe, MessageContext, APPLICATION_SCOPE } from 'lightning/messageService';

// export default class LmsSubscibe extends LightningElement {
//     @wire (MessageContext)
//     messageContext;

//     // connectedCallback(){
//     //     subscribe(this.messageContext, FILTERLMS, (message) => {console.log(message.messageText);}, { scope: APPLICATION_SCOPE });
//     // }

//     connectedCallback() {
//         // Subscribe to ProductsFiltered message
//         subscribe(
//             this.messageContext,
//             FILTERLMS,
//             (message) => { console.log(message.filters) }, {scope: APPLICATION_SCOPE}
//         );
//     }
    
// }

import { LightningElement, api, wire } from 'lwc';

// Use LMS and message channels to pass selected product from an event
import { subscribe, MessageContext, APPLICATION_SCOPE } from 'lightning/messageService';
import FILTERLMS from '@salesforce/messageChannel/filterProduct__c';


// import apex method to get products from a controller class
import getProducts from '@salesforce/apex/ProductController.getProducts';


export default class ProductCatalog extends LightningElement {
    @api searchBarVisible = false;

    @api tilesAreDraggable = false;
    
    // Declare default values for page number, products on page, and empty array for search filters
    pageNumber = 1;
    totalItemCount = 0;
    pageSize;
    filters={};
    productList = ''

    //Loads the context for the LMS
    @wire(MessageContext) messageContext;

    // use wire to access valid products and use $ to keep the filters and pageNum dynamic
    @wire(getProducts, { filters: '$filters', pageNumber: '$pageNumber'})
    products({data, error}) {
        if(data) {
            console.log('Data Without Stringify ' + data);
            console.log('Data: '+ JSON.stringify(data));
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
        this.pageNumber = 1;
    }

    handleFilterChange(message) {
        console.log(message.filters.inputValue);
        this.filters = {...message.filters};
        console.log("filters: " + this.filters);
        console.log("filters Category: " + this.filters.categories);
        this.pageNumber = 1;
    }

    // handlers for tracking the current page number
    handlePreviousPage() {
        this.pageNumber = this.pageNumber - 1;
    }
    handleNextPage() {
        this.pageNumber = this.pageNumber + 1;
    }
}