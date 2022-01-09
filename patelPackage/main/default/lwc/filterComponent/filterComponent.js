import { LightningElement, wire } from 'lwc';
import { publish, subscribe ,MessageContext } from 'lightning/messageService';
import FILTERLMS from "@salesforce/messageChannel/filterProduct__c";
import filterProducts from '@salesforce/apex/FilterProductController.getProduct';
import PRODUCTOBJ from '@salesforce/schema/Product2'; 
import {getObjectInfo,getPicklistValues} from 'lightning/uiObjectInfoApi';

import FAMILYFIELD from '@salesforce/schema/Product2.Family';



export default class FilterComponent extends LightningElement {
    inputValue;
    productList=''
    price = 100
    categoryValue=[];

    @wire(getObjectInfo,{objectApiName:PRODUCTOBJ})
    productObj

        
    @wire(getPicklistValues,{
        // recordTypeId: '012000000000000AAA',
        recordTypeId: '$productObj.data.defaultRecordTypeId',
        fieldApiName: FAMILYFIELD
    })categories
    
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
            filterData: {
                productList: this.productList,             
                price: this.price,
                categories: this.categoryValue
            }
        };
        publish(this.messageContext, FILTERLMS, messageSent);
        console.log('data from click handler'+ JSON.stringify(messageSent.filterData));
    }

    priceHandler(event){
        const price = event.target.value;
        this.price = price;
        console.log(price);
        
    }
    

    checkboxhandler(event){
        const {value} = event.target.dataset

        if (event.target.checked) {
            this.categoryValue.push(value);
        } else {
            const index = this.categoryValue.indexOf(value);
            if (index > -1) {
                this.categoryValue.splice(index);
                console.log(this.categoryValue);
            }
        }

    }


}