public with sharing class TimeCardService {
    @future(callout=true)
    public static void TimeCardCallout(ID timeCardID) {
        // Instantiate a new http object
        Http h = new Http();

        Time_Card__c timeCard = [SELECT id, EmployeeID__c, Date__c, Hours__c, Movie__c from Time_Card__c where id = :timeCardID];

        // Instantiate a new HTTP request, specify the method (POST) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:TimeCardEndpoint');
        req.setMethod('POST');
        req.setBody(JSON.serialize(timeCard));

        // Send the request, and return a response
        HttpResponse res = h.send(req);
        System.debug(res);
        System.debug(res.getBody()); 
    }
}
