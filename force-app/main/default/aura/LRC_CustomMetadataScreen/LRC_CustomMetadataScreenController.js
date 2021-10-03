({
	doInit: function(component, event, helper) {
        var spinner = component.find('spinner');
        $A.util.toggleClass(spinner, 'slds-hide');
        
        //helper.setFocusedTabLabel(component, event, helper);
        //helper.setFocusedTabIcon(component, event, helper);

        var action = component.get("c.getAvailableMetadata");

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                //console.log("@@AVAILABLE METADATA TYPES: " + JSON.stringify(response.getReturnValue()));
                var mapOptions = response.getReturnValue();
                var options = [];
                for(var key in mapOptions){
                    options.push({value: mapOptions[key], label: key});
                }
  	  			component.set("v.options", options);
                
        		$A.util.toggleClass(spinner, 'slds-show');
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " +  errors[0].message);
                        this.showToast(errors[0].message,'Error','error');
                    }
                } else {
                    this.showToast("Unknown error",'Error','error');
                }
            }
        });

        // optionally set storable, abortable, background flag here

        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
    },
    
    filter: function(component, event, helper) {
		helper.filter(component, event, helper);
    },
    
    onChangeSelect: function(component, event, helper) {
        //console.log('SELECTED VAL: ' +component.get("v.selectedValue"));
        component.set("v.showDatatable", true);
       
        helper.fetchMetadataRecords(component, event, helper);
    },
    
    readFile: function (component, event, helper) {
		var fileInput = component.find("fileId").get("v.files");
        //var fileInput = event.getSource().get("v.files");
        var file = fileInput[0];//fileInput.files[0];
        if (file) {            
            var reader = new FileReader();
            reader.readAsText(file, "UTF-8");
            
            reader.onload = function (evt) {
                var csv = evt.target.result;
                //console.log('@@@ csv file contains'+ csv);
                var result = helper.csvToJson(component,csv);
                helper.createMetadataFromCSV(component,result);
            }
            reader.onerror = function (evt) {
                this.showToast($A.get("$Label.c.LRC_Error_Reading_File"),'Error','error');
            }
        }    
    },
    
    handleFilesChange: function(component, event, helper) {
        var fileName = $A.get("$Label.c.LRC_No_Files_Selected");
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
        component.set("v.isUploadButtonDisabled", false);
    },
    
    doSave: function(component, event, helper) {
        if (component.find("fileId").get("v.files").length > 0) {
            helper.readFile(component, event, helper);
        } else {
            this.showToast($A.get("$Label.c.LRC_Select_Valid_File"),'Error','error');
        }
    },
    
    handleUploadFinished: function (component, event, helper) {
		// This will contain the List of File uploaded data and status
        var uploadedFiles = event.getParam("files");
       // console.log("Files uploaded : " + uploadedFiles.length);
    },
    
    handleSaveEdition: function (component, event, helper) {
        var draftValues = event.getParam('draftValues');
        var data = component.get("v.data");
        //console.log("@@DRAFT VALUES: "+ JSON.stringify(draftValues));
        //console.log("@@FILTERED DATA VALUES: "+ JSON.stringify(component.get("v.filteredData")));
        helper.saveEdition(component, event, draftValues);
    },
    
    handleCancelEdition: function (component) {
        // do nothing for now...
    }
})