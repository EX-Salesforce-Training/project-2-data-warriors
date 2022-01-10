({
    handleMessage : function(component, message) {
        console.log("subscribe Aura compo")
        if(message != null && message.getParam("filters")!=null){
            component.set("v.messageRecived", message.getParam("filters").value);
        }
    },

    inputHandler: function(component, event, helper){
        component.set("v.messageValue", event.target.value);

    },
    publishMessage:function(component){
        let msg = component.get("v.messageValue")
        let message = {
            filters:{
                value: msg
            }
        }
        component.find("filterProduct").publish(message);
    }
})
