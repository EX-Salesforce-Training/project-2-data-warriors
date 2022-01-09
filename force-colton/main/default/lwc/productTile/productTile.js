import { LightningElement, api, wire } from 'lwc';


// Use LMS and message channels to pass selected product from an event
import { publish, MessageContext } from 'lightning/messageService';
import SELECTED_PRODUCT_MESSAGE from '@salesforce/messageChannel/SelectedProduct__c';

export default class ProductTile extends LightningElement {

    // Loads the context for the LMS
    @wire(MessageContext) messageContext;

    _product;

    // getter and setter for product
    @api
    get product() {
        return this._product;
    }
    set product(value) {
        this._product = value;
        this.name = value.Name;
        this.prodCode = value.ProductCode;
        this.family = value.family;
        this.price = value.Product_Price__c;
    }

    name;
    prodCode;
    family;
    price;

    // Listens for a click to dispatch
    handleClick() {
        // const selectedEvent = new CustomEvent('selected', {
        //     detail: this.product.Id
        // });
        // this.dispatchEvent(selectedEvent);
        console.log(this.product.Id);
        publish(this.messageContext, SELECTED_PRODUCT_MESSAGE, {
            productId: this.product.Id
        });
    }

    // event to hand dragging tile
    handleDragStart(event) {
        event.dataTransfer.setData('product', JSON.stringify(this.product));
    }
}