@isTest
private class BillingCalloutServiceTest {
  //Implement mock callout tests here
  @TestSetup
  static void makeData(){
    ServiceCredentials__c cred = new ServiceCredentials__c();
    cred.Name = 'BillingServiceCredential';
    cred.Username__c = 'bsUser';
    cred.Password__c = 'bsPass';
    insert cred;

    Account a = new Account();
    a.Name = 'Test Account';
    insert a;

    
    Opportunity o = new Opportunity();
    o.Name = 'Test Opportunity';
    o.AccountId = a.Id;
    o.StageName = 'Negotiation/Review';
    o.CloseDate = Date.today();
    o.Type = 'New Project';

    insert o;

    Project__c proj = new Project__c();
    proj.Name = 'Test project';
    proj.Opportunity__c = o.Id;
    proj.ProjectRef__c = '123456789';
    proj.Billable_Amount__c = 100000;
    proj.Status__c = 'Running';
    proj.Start_Date__c = Date.today();
    proj.End_Date__c = Date.today().addDays(30);
    insert proj;

  }


  @isTest
  static void calloutSuccess() {
      Project__c proj = [SELECT Id, Status__c, ProjectRef__c, Billable_Amount__c 
                         FROM Project__c 
                         LIMIT 1];
      
      Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
      
      Test.startTest();
      proj.Status__c = 'Billable';
      update proj;
      Test.stopTest();
      
      Project__c updated = [SELECT Id, Status__c, ProjectRef__c, Billable_Amount__c 
                             FROM Project__c 
                             LIMIT 1];
      
      system.assertEquals('Billable', updated.Status__c,'Project status should be billable');
  }
  
  @isTest
  static void calloutFailure() {
      Project__c proj = [SELECT Id, Status__c, ProjectRef__c, Billable_Amount__c 
                         FROM Project__c 
                         LIMIT 1];
      
      Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
      
      Test.startTest();
      proj.Status__c = 'Billable';
      update proj;
      Test.stopTest();
      
      Project__c updated = [SELECT Id, Status__c, ProjectRef__c, Billable_Amount__c 
                             FROM Project__c 
                             LIMIT 1];
      
      system.assertEquals('Billable', updated.Status__c,'Project status should be billable');
  }
}