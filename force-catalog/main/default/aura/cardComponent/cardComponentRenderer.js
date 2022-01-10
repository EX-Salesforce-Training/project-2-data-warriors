({

// Your renderer method overrides go here

rerender : function(component, helper){
    this.superRerender();
},
afterRender: function (component, helper) {
    this.superAfterRender();
    helper.detailHelper(component, helper);
},
unrender: function () {
    this.superUnrender();
}

})
