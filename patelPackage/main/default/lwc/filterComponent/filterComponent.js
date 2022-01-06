import { LightningElement, wire } from 'lwc';
import { publish, subscribe ,MessageContext } from 'lightning/messageService';
import FILTERLMS from "@salesforce/messageChannel/filterProduct__c";
import filterProducts from '@salesforce/apex/FilterProductController.getProduct';

export default class FilterComponent extends LightningElement {
    inputValue;
    productList = ''
    
    @wire(MessageContext)
    messageContext;

    @wire(filterProducts,{value:'$inputValue'})
    filteredProducts({data, error}){
        if(data){
            this.productList = data;
            console.log('data from wire' + data);
        }
    }
    


    inputHandler(event){
        this.inputValue = event.target.value;
    }

    clickHandler(event){
        this.inputValue = event.target.value;
        const messageSent = {
            filterData: this.productList
        };
        publish(this.messageContext, FILTERLMS, messageSent);
        console.log('data from click handler'+ messageSent.filterData);
        
    }
  
  
    connectedCallBack(){
        console.log(this.productList);
    }
}