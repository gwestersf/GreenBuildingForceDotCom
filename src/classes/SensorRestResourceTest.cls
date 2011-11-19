@IsTest
public class SensorRestResourceTest {

    private static RestResponse doMyTest(String uri, String type, String value) {
        RestRequest request = new RestRequest();
        request.httpMethod = 'POST';
        request.requestURI = '/sensor/' + uri + '/';
        
        RestResponse response = new RestResponse();
        SensorRestResource.doPost(request, response, type, value);
        return response;
    }
    
    private static String createSensor(String name) {
        gwestr__Sensor__c mySensor = new gwestr__Sensor__c();
        mySensor.name = name;
        insert mySensor;
        return mySensor.id;
    }

    static testmethod void testPostSuccessCase() {
        String name = 'testSensor';
        createSensor(name);
        RestResponse response = doMyTest(name, 'Temperature', '80.0');
        
        System.debug(response.responseBody);
        System.assertEquals(204, response.statusCode);
    }
    
    
    
    static testmethod void testPostNullValue() {
    
    }
    
    static testmethod void testPostEmptyValue() {
    
    }
    
    static testmethod void testPostInvalidValue() {
    
    }
    
    static testmethod void testPost256CharValue() {
    
    }
    
    static testmethod void testPostBadSensorName() {
    
    }
    
    static testmethod void testPostSlashAndStuffAfterSensorName() {
    
    }
    
    static testmethod void testPostTypeNotInPicklist() {
    
    }
}