@RestResource(urlMapping='/sensor/*')
global with sharing class SensorRestResource {
    
    @HttpPost
    global static void doPost(RestRequest request, RestResponse response, String type, String value) {
        //return BAD REQUEST if value is null
        if(value == null) {
            response.statusCode = 400;
            return;
        }
        
        //pull the sensor name off the URL and look up the ID
        String sensorName = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);
        
        gwestr__Sensor__c activeSensor;
        try {
            activeSensor = [SELECT id FROM gwestr__Sensor__c WHERE name = :sensorName];
        } //return NOT FOUND if that sensor doesn't exist
        catch(System.QueryException e) {    
            response.statusCode = 404;
            response.responseBody = Blob.valueOf('Could not find sensor ' + sensorName);
            return;
        }
        
        //look up the picklist value
        List<Schema.PicklistEntry> picklistValues = 
            gwestr__Quantum__c.gwestr__Sensor__c.getDescribe().getPicklistValues();
        Schema.PicklistEntry typeFromPicklist = null;
        for(Schema.PicklistEntry picklistValue : picklistValues) {
           if(picklistValue.getValue() == type) {
              typeFromPicklist = picklistValue;
           }
        }
        
        //return BAD REQUEST if picklist value not valid
        if(typeFromPicklist == null) {
            response.statusCode = 400;
            return;
        }
        
        //create and insert our Quantum report
        gwestr__Quantum__c sensorReport = new Quantum__c();
        sensorReport.gwestr__Sensor__r = activeSensor;
        sensorReport.gwestr__Type__c = typeFromPicklist.getValue();
        sensorReport.gwestr__Value__c = value;
        insert sensorReport;
        
        //return success, NO CONTENT
        response.statusCode = 204;
        return;
    }

}