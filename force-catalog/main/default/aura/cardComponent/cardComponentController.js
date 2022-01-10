({
    doInit : function(component, event, helper) {
    
        var action = component.get("c.getAllProduct");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state=== "SUCCESS"){
                component.set("v.productList", response.getReturnValue());
    
            }
        });

     

        $A.enqueueAction(action);
    },

    handleMessage : function(component, event, message) {
        if(event != null) {
            const message = event.getParam();
            component.set("v.productList", "message" + message);
            console.log("message is: " + message);
        }
    }
})
