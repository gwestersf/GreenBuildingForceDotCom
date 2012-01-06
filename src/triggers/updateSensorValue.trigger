trigger updateSensorValue on Quantum__c (after insert, before update) {

      
      for (Quantum__c a : Trigger.new) { //for all records
        
        String sensorId = a.Sensor__c;
        Sensor__c s = [select id, name, LastLuminosity__c, LastMotion__c, LastTemperature__c from Sensor__c where id=:sensorId];
        
        
        if(a.Type__c=='Temperature') {
            s.LastTemperature__c = Decimal.valueOf(a.Value__c);
            
        } else if (a.Type__c=='Motion') {
            s.LastMotion__c = Decimal.valueOf(a.Value__c);
        
        } else if (a.Type__c=='Light') {
            s.LastLuminosity__c = Decimal.valueOf(a.Value__c);
        }
        
        update s;        
      }
      


}