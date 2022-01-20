({
    handleMessage : function(component, event, helper) {
        console.log("message: "+ event.getParam("productId"));
        component.set("v.productId",event.getParam("productId"));
    }
})
