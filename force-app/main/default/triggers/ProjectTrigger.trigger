trigger ProjectTrigger on Project__c (after update) {
    //Call the Billing Service callout logic here
    if(Trigger.isAfter && Trigger.isUpdate){
        BillingCalloutService.callBillingService(Trigger.new[0], Trigger.oldMap.get(Trigger.new[0].id));
    }
}