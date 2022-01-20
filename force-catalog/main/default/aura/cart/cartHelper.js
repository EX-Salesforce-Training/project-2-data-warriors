({
    createOrder : function(component, event, helper) {
        let createOrder = component.get("c.newOrder");
        createOrder.setParam({
            a
        });
        createOrder.setCallback(this, function(response){
            var state = response.getState();
            if(state=== "SUCCESS"){
                component.set("v.productList", response.getReturnValue());
            }
        });
        $A.enqueueAction(createOrder);
    }
})
