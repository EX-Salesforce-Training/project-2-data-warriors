({
    doInit : function(component, event, helper) {
        
    },

    getProducts:function(component, event, helper) {
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

    handleProductSelect: function (component, event, helper) {
        var payload = { productId: component.get("v.messageRecieved") };
        // Publish LMS message with payload
        component.find('selectedProduct').publish(payload);
    },

    handleMessage : function(component, event, helper) {
        component.set("v.messageRecieved",event.getParam("productId").value);
        component.set("v.showDetail",event.getParam("productId").detail);
    }
})
