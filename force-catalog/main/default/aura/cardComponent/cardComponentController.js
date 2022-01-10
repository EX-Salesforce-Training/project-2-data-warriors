({
    doInit : function(component, event, helper) {
        
    },


    doRender:function(component, event, helper){
      let detail = component.get("v.showDetail");
      if(detail){
          helper.fetchProducts(component, helper);
      }
    },

    handleProductSelect: function (component, event, helper) {
        
        var payload = { productId: component.get("v.messageRecieved") };
        console.log("Payload w/ stringify: " + JSON.stringify(payload));
        console.log("Payload w/o stringify: " + payload);

        // Publish LMS message with payload
        component.find('selectedProduct').publish(payload);
    },


    handleMessage : function(component, event, helper) {
        console.log("message: "+ event.getParam("productId").detail);
        component.set("v.messageRecieved",event.getParam("productId").value);
        component.set("v.showDetail",event.getParam("productId").detail);
    }
})
