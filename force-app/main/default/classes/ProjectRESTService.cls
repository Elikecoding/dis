@RestResource(urlMapping='/project/*')
global without sharing class ProjectRESTService {
    
    @HttpPost
    global static String postProjectData(String projectRef, String projectName, String opportunityId, 
                                        Date startDate, Date endDate, Double amount, String status){
        
        Savepoint sp = Database.setSavepoint();
        try {
            List<Opportunity> lstOfOpps = new List<Opportunity>();
            
            if(opportunityId != null && opportunityId.trim().length() > 0){
                Opportunity opp = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id = :opportunityId];
                opp.DeliveryInstallationStatus__c = 'In progress';
                                
                lstOfOpps.add(opp);
            }
            UPDATE lstOfOpps;

            List<Project__c> projList = new List<Project__c>();

            Project__c proj = new Project__c();
            proj.Name = projectName;
            proj.ProjectRef__c = projectRef;
            proj.Opportunity__c = opportunityId;
            proj.Start_Date__c  = startDate;
            proj.End_Date__c  = endDate;
            proj.Billable_Amount__c = amount;
            proj.Status__c = status;
            
            projList.add(proj);
            upsert projList;
    

            return 'OK';
        } catch (Exception e) {
            Database.rollback(sp);
            return e.getMessage();
        }
    }
}