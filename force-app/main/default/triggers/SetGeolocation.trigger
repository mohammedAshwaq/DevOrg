// Trigger runs getLocation() on Accounts with no Geolocation
trigger SetGeolocation on Account (after insert, after update) {
    for (Account a : trigger.new) {
        if (a.Location_Latitude__c == null)
            LocationCallouts.getLocation(a.id);
    }        
}