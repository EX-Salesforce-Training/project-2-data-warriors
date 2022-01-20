import { LightningElement, api, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import SELECTED_PRODUCT_MESSAGE from '@salesforce/messageChannel/SelectedProduct__c';

export default class ProductTile extends LightningElement { 
    @api product
    inputValue
    showDetail = false;

    @wire(MessageContext) messageContext;
    handleClick(event) {
        this.showDetail = !this.showDetail;
        this.inputValue= event.target.value;
        let message={
            productId:{
                value: this.inputValue,
                detail: this.showDetail
            }
        }

        publish(this.messageContext, SELECTED_PRODUCT_MESSAGE,message );
    }
}