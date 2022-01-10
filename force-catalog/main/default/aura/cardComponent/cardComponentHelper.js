({
    detailHelper : function(component, helper) {
        let detail = component.get("v.showDetail");
        console.log(detail);

    },

    fetchProducts: function(component, helper){
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
    }
})
