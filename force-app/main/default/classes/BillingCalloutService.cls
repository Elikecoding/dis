public class BillingCalloutService {
    //Implement business and callout logic methods here
    public static void callBillingService(List<Project__c> projectListNewValues,List<Project__c> projectListOldValues){
        
        for(Project__c project : projectList){
            BillingServiceProxy.project proxyProject = getDetailsForCallout(project);
        }
    }
}