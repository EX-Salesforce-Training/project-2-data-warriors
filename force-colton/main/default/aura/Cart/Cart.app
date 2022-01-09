<aura:application implements="flexipage:availableForAllPageTypes" access="global">

    <aura:attribute name="cartList" type="Product2[]" />

    
    <!-- method called on initialization -->
    <aura:handler name:"init" value="{!this}" action="{!c.doInit}" />

    <lightning:card>
        <aura:iteration items="{!v.cartList}" var="product">

        </aura:iteration>
    </lightning:card>

</aura:application>	
