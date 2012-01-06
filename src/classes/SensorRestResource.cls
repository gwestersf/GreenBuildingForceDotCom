@RestResource(urlMapping='/sensor/*')
global with sharing class SensorRestResource {
    
    @HttpPost
    global static void doPost(RestRequest request, RestResponse response, String sensor, String temperature, String motion, String light) {
        System.debug('got a request');
    
    
        //return BAD REQUEST if value is null
        if(sensor == null) {
            response.statusCode = 400;
            return;
        }

        gwestr__Sensor__c activeSensor;
        try {
            activeSensor = [SELECT id FROM gwestr__Sensor__c WHERE id = :sensor limit 1];
        } //return NOT FOUND if that sensor doesn't exist
        catch(System.QueryException e) {    
            response.statusCode = 404;
            response.responseBody = Blob.valueOf('Could not find sensor ' + sensor);
            return;
        }
        
        //create and insert our Quantum report
        
        if(temperature != null) {
            gwestr__Quantum__c sensorReport = new Quantum__c();
            sensorReport.gwestr__Sensor__c = activeSensor.id;
            sensorReport.gwestr__Type__c = 'Temperature';
            sensorReport.gwestr__Value__c = temperature;
            insert sensorReport;
        }
        if(motion != null) {
            gwestr__Quantum__c sensorReport = new Quantum__c();
            sensorReport.gwestr__Sensor__c = activeSensor.id;
            sensorReport.gwestr__Type__c = 'Motion';
            sensorReport.gwestr__Value__c = motion;
            insert sensorReport;
        }
        if(light != null) {
            gwestr__Quantum__c sensorReport = new Quantum__c();
            sensorReport.gwestr__Sensor__c = activeSensor.id;
            sensorReport.gwestr__Type__c = 'Light';
            sensorReport.gwestr__Value__c = light;
            insert sensorReport;
        }   
        
        //return success, NO CONTENT
        response.statusCode = 204;
        return;
    }

}