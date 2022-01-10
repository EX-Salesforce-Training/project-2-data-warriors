({
    doInit: function (component) {
        let getOrderId = component.get("c.OrderId");

        
        getOrderId.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.cases", response.getReturnValue());
            }
        });
        $A.enqueueAction(getOrderId);
    },

    handleClickSurvey: function (component, event, helper) {
        window.open("https://01tdmwe5ykn.typeform.com/to/EIXLVP9Z")
    },

    handleClickClose: function (component, event, helper) {
        component.set("v.isModalOpen", false);
    },

    handleClickOpen: function (component, event, helper) {
        component.set("v.isModalOpen", true);
    }
});


