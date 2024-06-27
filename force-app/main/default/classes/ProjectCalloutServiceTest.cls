@isTest
private class ProjectCalloutServiceTest {
	@testSetup
    static void makeData() {
        ServiceTokens__c token = new ServiceTokens__c();
        token.Name = 'ProjectServiceToken';
        token.Token__c = '123456789';
        insert token;
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        Account af = new Account();
        af.Name = 'Test Account Fail';
        insert af;
        
        Opportunity o = new Opportunity();
        o.Name = 'Test Opportunity';
        o.AccountId = a.Id;
        o.StageName = 'Submitted Project';
        o.CloseDate = Date.today();
        o.Type = 'New Project';
        insert o;

        Opportunity oppF = new Opportunity();
        oppF.Name = 'Test Opportunity Fail';
        oppF.AccountId = af.Id;
        oppF.StageName = 'Resubmit Project';
        oppF.CloseDate = Date.today();
        oppF.Type = 'New Project';
        insert oppF;
    }
    
    @isTest
    static void calloutSuccess() {
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
        
        Opportunity o = [SELECT Id, StageName FROM Opportunity WHERE StageName = 'Submitted Project' LIMIT 1];
        
        Test.startTest();
        ProjectCalloutService.postOpportunityToPMS(new List<Id>{o.Id});
        Test.stopTest();
        
        Opportunity updated = [SELECT Id, StageName FROM Opportunity WHERE StageName = 'Submitted Project' LIMIT 1];
        system.assertEquals('Submitted Project', updated.StageName, 'Stage name did not match expect value!');
    }
    
    @isTest
    static void calloutFailure() {
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
        
        Opportunity o = [SELECT Id, StageName FROM Opportunity WHERE StageName = 'Resubmit Project' LIMIT 1];
        
        Test.startTest();
        ProjectCalloutService.postOpportunityToPMS(new List<Id>{o.Id});
        Test.stopTest();
        
        Opportunity updated = [SELECT Id, StageName FROM Opportunity WHERE StageName = 'Resubmit Project' LIMIT 1];
        system.assertEquals('Resubmit Project', updated.StageName,'Stage name did not match expect value!');
    }
}