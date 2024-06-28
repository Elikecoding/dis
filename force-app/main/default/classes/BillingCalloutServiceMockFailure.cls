@isTest
public class BillingCalloutServiceMockFailure implements WebServiceMock{
   //Implement http mock callout failure here 
   public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType){
      BillingServiceProxy.billProjectResponse_element bpResponse = new BillingServiceProxy.billProjectResponse_element();
      bpResponse.status = 'error';
      response.put('response_x', bpResponse);
   }
}