import { LightningElement, api, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import SELECTED_PRODUCT_MESSAGE from '@salesforce/messageChannel/SelectedProduct__c';
import getProduct from '@salesforce/apex/ProductController.getProduct';

export default class ProductTile extends LightningElement { 
    @api product
    // @wire(getProduct)
    // prod({data, error}) {
    //     if(data) {
    //         this.ProductList = data;
    //     }
    // } //Product to be displayed

    @wire(MessageContext) messageContext;


    // @api
    // get product() {
    //     return this.prod;
    // }

    // set product(value) {
    //     this.prod = value;
    //     this.pictureUrl = value.DisplayUrl; //image URL
    //     this.name = value.Name;
    //     this.price = value.Product_Price__c;
    // }

    // set product(value) {
    //     this.prod = value;
    //     this.pictureUrl = "https://depositphotos.com/68657129/stock-photo-ring-binders.html";
    //     this.name = "3 ring binder";
    //     this.price = "$2.49";
    // }

    pictureUrl;
    name;
    price;

    handleClick(event) {
        
        console.log('Data: ' + event.target.value);
        console.log('Data Value: ' + event.target.dataset.value);
        const {id} = event.target.value;
        let message = {messageText: id};
        publish(this.messageContext, SELECTED_PRODUCT_MESSAGE, message);
    }
}