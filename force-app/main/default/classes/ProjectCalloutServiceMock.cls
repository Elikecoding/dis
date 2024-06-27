public class ProjectCalloutServiceMock implements HttpCalloutMock{
   //Implement http mock callout here
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        res.setStatusCode(201);
        return res;
    }
}