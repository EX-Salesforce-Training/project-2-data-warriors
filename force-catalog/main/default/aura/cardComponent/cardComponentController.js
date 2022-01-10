({
    doInit : function(component, event, helper) {


    },

    getProducts:function(component, event,helper){
        console.log(component.get("v.messageRecieved"));
        let id = component.get("v.messageRecieved");
        var action = component.get("c.getProductFromId");
        action.setParam('Id', id);
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state=== "SUCCESS"){
                component.set("v.productList", response.getReturnValue());
            }
        });

        $A.enqueueAction(action);

     
    },


    handleMessage : function(component, event, helper) {

        console.log("message: "+ event.getParam("productId").value);

            let msg = event.getParam("productId").value;
     
            component.set("v.messageRecieved",event.getParam("productId").value);

        
    }
})
