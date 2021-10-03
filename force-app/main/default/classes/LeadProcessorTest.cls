@isTest
private class LeadProcessorTest {
    @testSetup 
    static void setup() {
        List<Lead> leads= new List<Lead>();
        // insert 10 accounts
        for (Integer i=0;i<10;i++) {
            leads.add(new Lead(Title='Lead'+i, Company='Deloitte',LastName='testLead',LeadSource ='Dreamforce'));
        }
        insert leads;
    }
    static testmethod void test() {        
        Test.startTest();
        LeadProcessor ula = new LeadProcessor();
        Id batchId = Database.executeBatch(ula);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(10, [select count() from Lead where LeadSource = 'Dreamforce']);
    }
    
}