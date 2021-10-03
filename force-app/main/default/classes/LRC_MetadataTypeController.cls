/********************************************************************************************
* NAME         :  LRC_MetadataTypeController
* DESCRIPTION  :  This is a controller to handle mass insert/update operations from the Lightning component
*
* @AUTHOR Rahul Jichkar
* @DATE 21/12/2018
*
* MODIFICATION LOG:
* DEVELOPER                    DATE               DESCRIPTION
* ----------------------------------------------------------------------------                 
* Rahul Jichkar               21/12/2018         Created                                                                                                                                                                                
********************************************************************************************/
public class LRC_MetadataTypeController {
    //final variables created to be used throughout the class
    private static final String NONE_PICKLIST_VALUE = '---None---';
    private static final String CUSTOM_METADATA_EXT = '__mdt';
    private static final String CUSTOM_OBJECT_EXT = '__c';
    private static final String DEVELOPER_NAME = 'developername';
    private static final String MASTER_LABEL = 'masterlabel';
    private static final String SUCCESS = 'SUCCESS';
    
    //DataTypes 
    private static final String FIELD_TYPE_STRING = 'String';
    private static final String FIELD_TYPE_PICKLIST = 'Picklist';
    private static final String FIELD_TYPE_TEXT = 'text';
    private static final String FIELD_TYPE_DOUBLE = 'Double';
    private static final String FIELD_TYPE_NUMBER = 'number';
    
    /********************************************************************************************
    METHOD NAME    : getAvailableMetadata
    DESCRIPTION    : This method is used to get all the Custom MetadaType objects
    RETURN TYPE    : Map<String, String>
    PARAMETER      : void
    ********************************************************************************************/
    @AuraEnabled
    public static Map<String, String> getAvailableMetadata(){
        Map<String, String> mapCustMetadata = new Map<String, String>();
        mapCustMetadata.put(NONE_PICKLIST_VALUE, NONE_PICKLIST_VALUE);
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
            String apiName = objTyp.getDescribe().getName();
            String label = objTyp.getDescribe().getLabel();
            
            // Exclude all the unwanted Sobjects e.g. History, Share etc..           
            if(apiName.containsignorecase(CUSTOM_METADATA_EXT)){      
                mapCustMetadata.put(label, apiName);
            }  
        }
        return mapCustMetadata;
    }
    
    /********************************************************************************************
    METHOD NAME    : getMetadataRecords
    DESCRIPTION    : This method gets the columns & data from the selected Custom MetadataType object
    RETURN TYPE    : DataWrapper
    PARAMETER      : String
    ********************************************************************************************/
    @AuraEnabled
    public static DataWrapper getMetadataRecords(String sObj){
        DataWrapper dataWrap = new DataWrapper();
        List<ColumnsWrapper> lstCols = new List<ColumnsWrapper>();
        try{   
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Map<String, Schema.SObjectField> fieldMap = schemaMap.get(sObj).getDescribe().fields.getMap();
            List<String> lstFieldNames = new List<String>();
    
            for(String fieldName : fieldMap.keyset()){
                if(fieldName.contains(CUSTOM_OBJECT_EXT) || fieldName.contains(DEVELOPER_NAME) || fieldName.contains(MASTER_LABEL)){
                    DescribeFieldresult fieldDesc = fieldMap.get(fieldName).getDescribe();
                    String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();
                    String fieldAPIName = fieldDesc.getName();
                    String fieldType = String.valueOf(fieldMap.get(fieldName).getDescribe().getType());
                    if(fieldType.containsIgnoreCase(FIELD_TYPE_STRING) || fieldType.containsIgnoreCase(FIELD_TYPE_PICKLIST)){
                        fieldType = FIELD_TYPE_TEXT;
                    }
                    if(fieldType.containsIgnoreCase(FIELD_TYPE_DOUBLE)){
                        fieldType = FIELD_TYPE_NUMBER;
                    }
                    lstCols.add(new ColumnsWrapper(fieldLabel, fieldAPIName, fieldType.toLowerCase()));
                    lstFieldNames.add(fieldName);
                }
            }
            String sQuery = 'SELECT ' + String.join( lstFieldNames, ',' ) + ' FROM '+ sObj;
            system.debug('@@SQUERY: '+sQuery);
            
            List<Object> lstMedataRecords = Database.query(sQuery);
            dataWrap.lstCols = lstCols;
            dataWrap.lstData = lstMedataRecords;
        }catch(Exception ex){
            throw new AuraHandledException(Label.LRC_Error_Message);
        }
        return dataWrap;
    }

    
    /********************************************************************************************
    METHOD NAME    : saveRecords
    DESCRIPTION    : This method deploys the metadata type records using Metadata API
    RETURN TYPE    : String
    PARAMETER      : String sObj, String draftValues, String data
    ********************************************************************************************/
    @AuraEnabled
    public static String saveRecords(String sObj, String draftValues, String data){
        try{
            List<Object> lstDraftValues = (List<Object>) JSON.deserializeUntyped(draftValues);
            List<Object> lstData = (List<Object>) JSON.deserializeUntyped(data);
            Map<String, Map<String, Object>> mapData = new Map<String, Map<String, Object>>();
            Map<String, Map<String, Object>> mapDraftValues = new Map<String, Map<String, Object>>();
            
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Map<String, Schema.SObjectField> fieldMap = schemaMap.get(sObj).getDescribe().fields.getMap();
            List<Metadata.CustomMetadata> lstCustomMetadata = new List<Metadata.CustomMetadata>();
            
            for(Object obj : lstData){
                Map<String, Object> m = (Map<String, Object>) obj;
                mapData.put((String)m.get('rowId'), m);            
            }
            
            for(Object obj : lstDraftValues){
                Map<String, Object> m = (Map<String, Object>) obj; 
                mapDraftValues.put((String)m.get('id'), m); 
            }
    
            for(String rowId : mapData.keySet()){
                // Set up custom metadata to be created in the subscriber org.
                Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
                
                for(String fieldName : fieldMap.keyset()){
                    DescribeFieldresult fieldDesc = fieldMap.get(fieldName).getDescribe();
                    system.debug('@@FIELD NAME: '+fieldName);
                    if(fieldName.contains(DEVELOPER_NAME)){
                        if(mapDraftValues.containsKey(rowId) && mapDraftValues.get(rowId).containsKey(fieldDesc.getName())){
                            //system.debug('DRAFT FULL NAME FIELD: '+  + ' VALUE: '+ mapDraftValues.get(rowId).get(fieldDesc.getName()));
                            customMetadata.fullName = sObj.removeEnd(CUSTOM_METADATA_EXT) + '.' + (String)mapDraftValues.get(rowId).get(fieldDesc.getName());
                        }else{
                            //system.debug('DATA FULL NAME FIELD: '+ fieldDesc.getName() + ' VALUE: '+ mapData.get(rowId).get(fieldDesc.getName()));
                            customMetadata.fullName = sObj.removeEnd(CUSTOM_METADATA_EXT) + '.' + (String)mapData.get(rowId).get(fieldDesc.getName());
                        }
                    }
                    if(fieldName.contains(MASTER_LABEL)){
                        if(mapDraftValues.containsKey(rowId) && mapDraftValues.get(rowId).containsKey(fieldDesc.getName())){
                            //system.debug('DRAFT LABEL FIELD: '+  + ' VALUE: '+ mapDraftValues.get(rowId).get(fieldDesc.getName()));
                            customMetadata.label = (String)mapDraftValues.get(rowId).get(fieldDesc.getName());
                        }else{
                            //system.debug('DATA LABEL FIELD: '+ fieldDesc.getName() + ' VALUE: '+ mapData.get(rowId).get(fieldDesc.getName()));
                            customMetadata.label = (String)mapData.get(rowId).get(fieldDesc.getName());
                        }
                    }
                    if(fieldName.contains(CUSTOM_OBJECT_EXT)){
                        Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
                        customField.field = fieldDesc.getName();
                        if(mapDraftValues.containsKey(rowId) && mapDraftValues.get(rowId).containsKey(fieldDesc.getName())){
                            //system.debug('DRAFT FIELD: '+  + ' VALUE: '+ mapDraftValues.get(rowId).get(fieldDesc.getName()));
                            customField.value = mapDraftValues.get(rowId).get(fieldDesc.getName());
                        }else{
                            //system.debug('DATA FIELD: '+ fieldDesc.getName() + ' VALUE: '+ mapData.get(rowId).get(fieldDesc.getName()));
                            customField.value = mapData.get(rowId).get(fieldDesc.getName());
                        }
                        customMetadata.values.add(customField);
                    }
                }
                lstCustomMetadata.add(customMetadata);
            }
            system.debug('@@LIST CUSTOMETA: '+ lstCustomMetadata);
            //Deploy Metadata Records
            deployMetadataTypeRecords(lstCustomMetadata);
        }catch(Exception ex){
            throw new AuraHandledException(Label.LRC_Error_Message);
        }
        return SUCCESS;
    }
    
    /********************************************************************************************
    METHOD NAME    : saveCSVRecords
    DESCRIPTION    : This method deploys the metadata type records from the CSV file using Metadata API.
    RETURN TYPE    : String
    PARAMETER      : String sObj, String jsonStr
    ********************************************************************************************/
    @AuraEnabled
    public static String saveCSVRecords(String sObj, String jsonStr){
        try{
            List<Object> lstData = (List<Object>) JSON.deserializeUntyped(jsonStr);
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Map<String, Schema.SObjectField> fieldMap = schemaMap.get(sObj).getDescribe().fields.getMap();
            List<Metadata.CustomMetadata> lstCustomMetadata = new List<Metadata.CustomMetadata>();
                 
            for(Object obj : lstData){
                // Set up custom metadata to be created in the subscriber org.
                Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
                
                for(String fieldName : fieldMap.keyset()){
                    DescribeFieldresult fieldDesc = fieldMap.get(fieldName).getDescribe();
                    
                    Map<String, Object> mapData = (Map<String, Object>) obj;
                    system.debug('FIELD: '+ fieldDesc.getName() +' VALUE: ' + mapData.get(fieldDesc.getName()));
                    
                    if(fieldName.contains(DEVELOPER_NAME)){
                        customMetadata.fullName = sObj.removeEnd(CUSTOM_METADATA_EXT) + '.' + mapData.get(fieldDesc.getName());
                    }
                    if(fieldName.contains(MASTER_LABEL)){
                        customMetadata.label = (String)mapData.get(fieldDesc.getName());
                    }
                    if(fieldName.contains(CUSTOM_OBJECT_EXT)){
                        Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
                        customField.field = fieldDesc.getName();
                        customField.value = mapData.get(fieldDesc.getName());
                        customMetadata.values.add(customField);
                    }   
                }  
                lstCustomMetadata.add(customMetadata);            
            } 
            system.debug('@@CSV LIST CUSTOMETA: '+ lstCustomMetadata);
            
            //Deploy Metadata Records
            deployMetadataTypeRecords(lstCustomMetadata);
        }catch(Exception ex){
            throw new AuraHandledException(Label.LRC_Error_Message);
        }
        return SUCCESS;
    }
    
   /********************************************************************************************
    METHOD NAME    : deployMetadataTypeRecords
    DESCRIPTION    : This method creates the deployment container for deploying metadata records.
    RETURN TYPE    : void
    PARAMETER      : List<Metadata.CustomMetadata> lstCustomMetadata
    ********************************************************************************************/
    private static void deployMetadataTypeRecords(List<Metadata.CustomMetadata> lstCustomMetadata){
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        for(Metadata.CustomMetadata customMetadata : lstCustomMetadata){
        	mdContainer.addMetadata(customMetadata);
        }      
        // Setup deploy callback, MyDeployCallback implements
        // the Metadata.DeployCallback interface
        LRC_CustomMetadataCallback  callback = new LRC_CustomMetadataCallback ();
        
        // Enqueue custom metadata deployment
        // jobId is the deployment ID
        if(!Test.isRunningTest()){
        	Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback); 
        }
    }
    
    //Wrapper class for collecting cloumns data
    public class ColumnsWrapper{
        public ColumnsWrapper(String fieldLabel, String fieldName, String fieldType){
            this.fieldLabel = fieldLabel;
            this.fieldName = fieldName;
            this.fieldType = fieldType;
        }
        @AuraEnabled
        public String fieldLabel {get;set;}
        @AuraEnabled
        public String fieldName {get;set;}
        @AuraEnabled
        public String fieldType {get;set;}
    }
    
    //Wrapper class for enclosing cloumns data & records
    public class DataWrapper{
        @AuraEnabled
        public List<ColumnsWrapper> lstCols {get;set;}
        @AuraEnabled
        public List<Object> lstData {get;set;}
    }
}