/********************************************************************************************
* NAME         :  LRC_MetadataTypeControllerTest
* DESCRIPTION  :  This is a test class for LRC_MetadataTypeController
*
* @AUTHOR Rahul Jichkar
* @DATE 21/12/2018
*
* MODIFICATION LOG:
* DEVELOPER                    DATE               DESCRIPTION
* ----------------------------------------------------------------------------                 
* Rahul Jichkar               21/12/2018         Created                                                                                                                                                                                
********************************************************************************************/
@isTest
private class LRC_MetadataTypeControllerTest {
    private static string expectedResult = 'SUCCESS';
    
	static testMethod void testAvailableMetadataTypes() {
		LRC_MetadataTypeController.getAvailableMetadata();
    }
    
    static testMethod void testAvailableMetadataTypeRecords() {
		LRC_MetadataTypeController.getMetadataRecords('Sample_Data__mdt');
    }
    
    static testMethod void testSaveRecords() {        
		String successScene1 = LRC_MetadataTypeController.saveRecords('Sample_Data__mdt','[{"MasterLabel":"Tested","id":"row-0"}]','[{"DeveloperName":"Test","MasterLabel":"Test","rowId":"row-0"}]');
        String successScene2 = LRC_MetadataTypeController.saveRecords('Sample_Data__mdt','[{"DeveloperName":"Tested","id":"row-0"}]','[{"DeveloperName":"Test","MasterLabel":"Test","rowId":"row-0"}]');
        String successScene3 = LRC_MetadataTypeController.saveRecords('Sample_Data__mdt','[{"Custom_Field__c":"Tested","id":"row-0"}]','[{"DeveloperName":"Test","MasterLabel":"Test","rowId":"row-0"}]');
    	System.assertEquals(expectedResult, successScene1);
        System.assertEquals(expectedResult, successScene2);
        System.assertEquals(expectedResult, successScene3);
    }
    
    static testMethod void testSaveCSVRecords() {
		String successScene1 = LRC_MetadataTypeController.saveCSVRecords('Sample_Data__mdt','[{"DeveloperName":"Test","MasterLabel":"Test","Id":"m026F000000YrNwQAK","rowId":"row-0"}]');
    	System.assertEquals(expectedResult, successScene1);
    }
}